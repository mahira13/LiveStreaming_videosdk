import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'spacer.dart';

void showSnackBarMessage(
    {required String message, Widget? icon, required BuildContext context}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      behavior: SnackBarBehavior.floating,
      backgroundColor: unselectedColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Row(
        children: [
          if (icon != null) icon,
          if (icon != null) const HorizontalSpacer(),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: bodyTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.fade,
            ),
          )
        ],
      )));
}
