import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:videosdk/videosdk.dart';

import '../../constants/app_colors.dart';
import '../../utils/toast.dart';
import 'widgets/hostview_action_bar.dart';
import 'widgets/hostview_appbar.dart';
import 'widgets/participants_grid/participant_grid.dart';

class HostView extends StatefulWidget {
  final Room meeting;
  final String token;
  const HostView({super.key, required this.meeting, required this.token});

  @override
  State<HostView> createState() => _HostViewState();
}

class _HostViewState extends State<HostView> {
  bool showChatSnackbar = true;

  // Streams
  Stream? shareStream;
  Stream? videoStream;
  Stream? audioStream;
  Stream? remoteParticipantShareStream;

  bool fullScreen = false;

  @override
  void initState() {
    super.initState();
    // Register meeting events
    registerMeetingEvents(widget.meeting);
    ;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusbarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          HostAppBar(
            meeting: widget.meeting,
            token: widget.token,
            isFullScreen: fullScreen,
          ),
          Expanded(
            child: GestureDetector(
                onDoubleTap: () => {
                      setState(() {
                        fullScreen = !fullScreen;
                      })
                    },
                child: OrientationBuilder(builder: (context, orientation) {
                  return Flex(
                    direction: orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal,
                    children: [
                      Flexible(
                          child: ParticipantGrid(
                              meeting: widget.meeting,
                              orientation: orientation))
                    ],
                  );
                })),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: !fullScreen
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            secondChild: const SizedBox.shrink(),
            firstChild: HostActionBar(
              isMicEnabled: audioStream != null,
              isCamEnabled: videoStream != null,
              isScreenShareEnabled: shareStream != null,
              // Called when Call End button is pressed
              onCallEndButtonPressed: () {
                widget.meeting.end();
              },

              onCallLeaveButtonPressed: () {
                widget.meeting.leave();
              },
              // Called when mic button is pressed
              onMicButtonPressed: () {
                if (audioStream != null) {
                  widget.meeting.muteMic();
                } else {
                  widget.meeting.unmuteMic();
                }
              },
              // Called when camera button is pressed
              onCameraButtonPressed: () {
                if (videoStream != null) {
                  widget.meeting.disableCam();
                } else {
                  widget.meeting.enableCam();
                }
              },

              onSwitchMicButtonPressed: (details) async {
                List<MediaDeviceInfo> outptuDevice =
                    widget.meeting.getAudioOutputDevices();
                double bottomMargin = (70.0 * outptuDevice.length);
                final screenSize = MediaQuery.of(context).size;
                await showMenu(
                  context: context,
                  color: black700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  position: RelativeRect.fromLTRB(
                    screenSize.width - details.globalPosition.dx,
                    details.globalPosition.dy - bottomMargin,
                    details.globalPosition.dx + 50,
                    (bottomMargin),
                  ),
                  items: outptuDevice.map((e) {
                    return PopupMenuItem(value: e, child: Text(e.label));
                  }).toList(),
                  elevation: 8.0,
                ).then((value) {
                  if (value != null) {
                    widget.meeting.switchAudioDevice(value);
                  }
                });
              },

              onSwitchCameraButtonPressed: (details) async {
                List<MediaDeviceInfo> outptuDevice =
                    widget.meeting.getCameras();
                double bottomMargin = (70.0 * outptuDevice.length);
                final screenSize = MediaQuery.of(context).size;
                await showMenu(
                  context: context,
                  color: black700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  position: RelativeRect.fromLTRB(
                    screenSize.width - details.globalPosition.dx,
                    details.globalPosition.dy - bottomMargin,
                    details.globalPosition.dx,
                    (bottomMargin),
                  ),
                  items: outptuDevice.map((e) {
                    return PopupMenuItem(value: e, child: Text(e.label));
                  }).toList(),
                  elevation: 8.0,
                ).then((value) {
                  if (value != null) {
                    widget.meeting.changeCam(value.deviceId);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void registerMeetingEvents(Room _meeting) {
    // Called when stream is enabled
    _meeting.localParticipant.on(Events.streamEnabled, (Stream _stream) {
      if (_stream.kind == 'video') {
        setState(() {
          videoStream = _stream;
        });
      } else if (_stream.kind == 'audio') {
        setState(() {
          audioStream = _stream;
        });
      } else if (_stream.kind == 'share') {
        setState(() {
          shareStream = _stream;
        });
      }
    });

    // Called when stream is disabled
    _meeting.localParticipant.on(Events.streamDisabled, (Stream _stream) {
      if (_stream.kind == 'video' && videoStream?.id == _stream.id) {
        setState(() {
          videoStream = null;
        });
      } else if (_stream.kind == 'audio' && audioStream?.id == _stream.id) {
        setState(() {
          audioStream = null;
        });
      } else if (_stream.kind == 'share' && shareStream?.id == _stream.id) {
        setState(() {
          shareStream = null;
        });
      }
    });

    _meeting.on(
        Events.error,
        (error) => {
              if (mounted)
                {
                  showSnackBarMessage(
                      message: error['name'].toString() +
                          " :: " +
                          error['message'].toString(),
                      context: context)
                }
            });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
