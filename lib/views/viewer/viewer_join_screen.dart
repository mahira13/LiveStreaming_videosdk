import 'package:flutter/material.dart';

import 'package:videosdk/videosdk.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../services/videosdk_api.dart';
import '../../utils/spacer.dart';
import '../../utils/toast.dart';
import '../livestream_screen.dart';

// Join Screen
class ViewerJoinScreen extends StatefulWidget {
  const ViewerJoinScreen({Key? key}) : super(key: key);

  @override
  State<ViewerJoinScreen> createState() => _ViewerJoinScreenState();
}

class _ViewerJoinScreenState extends State<ViewerJoinScreen> {
  String _token = "";
  TextEditingController meetingIdTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await fetchToken(context);
      setState(() {
        _token = token;
      });
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
            watchLiveStream,
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
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                    TextFormField(
                      controller: meetingIdTextController,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          hintText: hintTextMeetingCode,
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
                        child: const Text(watchButton,
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

  Future<void> joinMeeting() async {
    if (meetingIdTextController.text.isEmpty) {
      showSnackBarMessage(
          message: "Please enter Valid Meeting ID", context: context);
      return;
    }

    if (nameTextController.text.isEmpty) {
      showSnackBarMessage(message: "Please enter Name", context: context);
      return;
    }
    String meetingId = meetingIdTextController.text;
    String name = nameTextController.text;
    var validMeeting = await validateMeeting(_token, meetingId);
    if (context.mounted) {
      if (validMeeting) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ILSScreen(
              token: _token,
              meetingId: meetingId,
              displayName: name,
              micEnabled: false,
              camEnabled: false,
              mode: Mode.VIEWER,
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
    super.dispose();
  }
}
