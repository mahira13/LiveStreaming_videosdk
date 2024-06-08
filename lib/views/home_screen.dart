import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/spacer.dart';
import 'host/create_livestream_screen.dart';
import 'viewer/viewer_join_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appbarBackgroundColor,
          title: const Text(
            appTitle,
            style: TextStyle(color: bodyTextColor),
          )),
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text(createLiveStream,
                    style: TextStyle(fontSize: 16)),
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateLiveStreamScreen(
                                  isCreateMeeting: true)))
                    }),
            const VerticalSpacer(32),
            Row(
              children: const [
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: black750,
                )),
                HorizontalSpacer(),
                Text("OR"),
                HorizontalSpacer(),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: black750,
                )),
              ],
            ),
            const VerticalSpacer(32),
            ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all(unselectedColor)),
                child:
                    const Text(watchLiveStream, style: TextStyle(fontSize: 16)),
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewerJoinScreen()))
                    }),
          ],
        ),
      )),
    );
  }
}
