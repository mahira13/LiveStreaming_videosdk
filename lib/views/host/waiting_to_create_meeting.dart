import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../utils/spacer.dart';

class WaitingToCreate extends StatelessWidget {
  const WaitingToCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VerticalSpacer(20),
            const Text(
              "Creating...",
              style: TextStyle(
                  fontSize: 20,
                  color: bodyTextColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
