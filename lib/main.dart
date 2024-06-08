import 'package:flutter/material.dart';

import 'constants/app_strings.dart';
import 'themes/app_theme.dart';
import 'views/home_screen.dart';

void main() {
  // Run Flutter App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Material App
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
