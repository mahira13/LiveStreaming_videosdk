import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videosdk/videosdk.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../services/videosdk_api.dart';
import '../../utils/spacer.dart';
import '../../utils/toast.dart';
import '../livestream_screen.dart';

// Join Screen
class CreateLiveStreamScreen extends StatefulWidget {
  final bool isCreateMeeting;
  const CreateLiveStreamScreen({Key? key, required this.isCreateMeeting})
      : super(key: key);

  @override
  State<CreateLiveStreamScreen> createState() => _CreateLiveStreamScreenState();
}

class _CreateLiveStreamScreenState extends State<CreateLiveStreamScreen> {
  String _token = "";

  // Control Status
  bool isMicOn = true;
  bool isCameraOn = true;

  CustomTrack? cameraTrack;
  RTCVideoRenderer? cameraRenderer;

  TextEditingController meetingIdTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  @override
  void initState() {
    initCameraPreview();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await fetchToken(context);
      setState(() {
        _token = token;
      });
      if (widget.isCreateMeeting) {
        final meetingId = await createMeeting(token);
        setState(() {
          meetingIdTextController.value = TextEditingValue(text: meetingId);
        });
      }
    });
  }

  @override
  setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appbarBackgroundColor,
          title: const Text(
            createLiveStream,
            style: TextStyle(color: bodyTextColor),
          )),
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Camera Preview
              SizedBox(
                height: 300,
                width: 200,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (cameraRenderer != null)
                      SizedBox(
                        height: 300,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: RTCVideoView(
                            cameraRenderer as RTCVideoRenderer,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 16,

                      // Meeting ActionBar
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Mic Action Button
                            IconButton(
                              onPressed: () => setState(
                                () => isMicOn = !isMicOn,
                              ),
                              icon: Icon(isMicOn ? Icons.mic : Icons.mic_off,
                                  color: !isMicOn
                                      ? unselectedColor
                                      : iconColorWhite),
                            ),
                            IconButton(
                              onPressed: () {
                                if (isCameraOn) {
                                  disposeCameraPreview();
                                } else {
                                  initCameraPreview();
                                }
                                setState(() => isCameraOn = !isCameraOn);
                              },
                              icon: Icon(
                                isCameraOn
                                    ? Icons.videocam
                                    : Icons.videocam_off,
                                color: !isCameraOn
                                    ? unselectedColor
                                    : iconColorWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.isCreateMeeting)
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: black750),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Meeting code: ${meetingIdTextController.text}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            GestureDetector(
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Icon(
                                  Icons.copy,
                                  size: 16,
                                ),
                              ),
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: meetingIdTextController.text));
                                showSnackBarMessage(
                                    message: "Meeting ID has been copied.",
                                    context: context);
                              },
                            ),
                          ],
                        ),
                      ),
                    if (widget.isCreateMeeting) const VerticalSpacer(16),
                    TextFormField(
                      controller: nameTextController,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          hintText: enterName,
                          hintStyle: TextStyle(color: hintTextColor),
                          fillColor: Colors.white),
                    ),
                    const VerticalSpacer(16),
                    ElevatedButton(
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style
                            ?.copyWith(
                                backgroundColor:
                                    MaterialStateProperty.all(primaryColor)),
                        child: const Text(createButton,
                            style: TextStyle(fontSize: 16)),
                        onPressed: () => {joinMeeting()}),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  void initCameraPreview() async {
    CustomTrack track = await VideoSDK.createCameraVideoTrack();
    RTCVideoRenderer render = RTCVideoRenderer();
    await render.initialize();
    render.setSrcObject(stream: track.mediaStream);
    setState(() {
      cameraTrack = track;
      cameraRenderer = render;
    });
  }

  void disposeCameraPreview() {
    cameraTrack?.dispose();
    setState(() {
      cameraRenderer = null;
      cameraTrack = null;
    });
  }

  Future<void> joinMeeting() async {
    if (meetingIdTextController.text.isEmpty) {
      showSnackBarMessage(message: invalidMeetingId, context: context);
      return;
    }
    if (nameTextController.text.isEmpty) {
      showSnackBarMessage(message: enterName, context: context);
      return;
    }
    String meetingId = meetingIdTextController.text;
    String name = nameTextController.text;
    var validMeeting = await validateMeeting(_token, meetingId);
    if (context.mounted) {
      if (validMeeting) {
        disposeCameraPreview();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ILSScreen(
              token: _token,
              meetingId: meetingId,
              displayName: name,
              micEnabled: isMicOn,
              camEnabled: isCameraOn,
              mode: Mode.CONFERENCE,
            ),
          ),
        );
      } else {
        showSnackBarMessage(message: "Invalid Meeting ID", context: context);
      }
    }
  }

  @override
  void dispose() {
    cameraTrack?.dispose();
    super.dispose();
  }
}
