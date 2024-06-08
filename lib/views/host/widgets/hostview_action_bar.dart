import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/spacer.dart';

// Meeting ActionBar
class HostActionBar extends StatelessWidget {
  // control states
  final bool isMicEnabled, isCamEnabled, isScreenShareEnabled;

  // callback functions
  final void Function() onCallEndButtonPressed,
      onCallLeaveButtonPressed,
      onMicButtonPressed,
      onCameraButtonPressed;

  final void Function(TapDownDetails) onSwitchMicButtonPressed;
  final void Function(TapDownDetails) onSwitchCameraButtonPressed;
  const HostActionBar(
      {Key? key,
      required this.isMicEnabled,
      required this.isCamEnabled,
      required this.isScreenShareEnabled,
      required this.onCallEndButtonPressed,
      required this.onCallLeaveButtonPressed,
      required this.onMicButtonPressed,
      required this.onSwitchMicButtonPressed,
      required this.onCameraButtonPressed,
      required this.onSwitchCameraButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PopupMenuButton(
              position: PopupMenuPosition.under,
              padding: const EdgeInsets.all(0),
              color: black700,
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: red),
                  color: red,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.call_end,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) => {
                    if (value == "leave")
                      onCallLeaveButtonPressed()
                    else if (value == "end")
                      onCallEndButtonPressed()
                  },
              itemBuilder: (context) => <PopupMenuEntry>[
                    _buildMeetingPoupItem(
                      "leave",
                      "Leave",
                      "Only you will leave the call",
                      SvgPicture.asset("assets/ic_leave.svg"),
                    ),
                    const PopupMenuDivider(),
                    _buildMeetingPoupItem(
                      "end",
                      "End",
                      "End call for all participants",
                      SvgPicture.asset("assets/ic_end.svg"),
                    ),
                  ]),
          const HorizontalSpacer(8),
          // Mic Control
          TouchRippleEffect(
            borderRadius: BorderRadius.circular(12),
            rippleColor: isMicEnabled ? primaryColor : Colors.white,
            onTap: onMicButtonPressed,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: secondaryColor),
                color: isMicEnabled ? primaryColor : Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    isMicEnabled ? Icons.mic : Icons.mic_off,
                    size: 26,
                    color: isMicEnabled ? Colors.white : primaryColor,
                  ),
                  GestureDetector(
                      onTapDown: (details) =>
                          {onSwitchMicButtonPressed(details)},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 16,
                          color: isMicEnabled ? Colors.white : primaryColor,
                        ),
                      )),
                ],
              ),
            ),
          ),
          const HorizontalSpacer(8),

          // Camera Control
          TouchRippleEffect(
            borderRadius: BorderRadius.circular(12),
            rippleColor: primaryColor,
            onTap: onCameraButtonPressed,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: secondaryColor),
                color: isCamEnabled ? primaryColor : Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    isCamEnabled
                        ? "assets/ic_video.svg"
                        : "assets/ic_video_off.svg",
                    width: 24,
                    height: 24,
                    color: isCamEnabled ? Colors.white : primaryColor,
                  ),
                  const HorizontalSpacer(8),
                  GestureDetector(
                      onTapDown: (details) =>
                          {onSwitchCameraButtonPressed(details)},
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: isCamEnabled ? Colors.white : primaryColor,
                        size: 16,
                      )),
                ],
              ),
            ),
          ),
          const HorizontalSpacer(8),
        ],
      ),
    );
  }

  PopupMenuItem<dynamic> _buildMeetingPoupItem(
      String value, String title, String? description, Widget leadingIcon) {
    return PopupMenuItem(
      value: value,
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Row(children: [
        leadingIcon,
        const HorizontalSpacer(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            if (description != null) const VerticalSpacer(4),
            if (description != null)
              Text(
                description,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500, color: black400),
              )
          ],
        )
      ]),
    );
  }
}
