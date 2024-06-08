// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

ThemeData defaultTheme = ThemeData(
  primaryColor: primaryColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    minimumSize: MaterialStateProperty.all(
      Size.fromHeight(52),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(29.0),
    )),
    backgroundColor: MaterialStateProperty.all(primaryColor),
  )),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
      // fixedSize: MaterialStateProperty.all(
      //   Size.fromHeight(6),
      // ),
    ),
  ),
  tabBarTheme: TabBarTheme(
      labelStyle: TextStyle(fontSize: 18),
      unselectedLabelStyle: TextStyle(fontSize: 18)),
  scaffoldBackgroundColor: backgroundColor,
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  appBarTheme: AppBarTheme(
      backgroundColor: appbarBackgroundColor,
      titleTextStyle: TextStyle(color: Colors.black)),
  
  textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
      headline2: TextStyle(
          fontSize: 24, color: Colors.black, fontWeight: FontWeight.w900),
      headline3: TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
      headline4: TextStyle(
          fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
      headline5: TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
      headline6: TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      subtitle1: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      subtitle2: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyText1: TextStyle(
          fontSize: 16, color: bodyTextColor, fontWeight: FontWeight.normal),
      bodyText2: TextStyle(
        fontSize: 14,
        color: bodyTextColor,
      ),
      button: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(fontSize: 14, color: subtitleColor)),
  iconTheme: IconThemeData(color: Colors.white),
  primaryIconTheme: IconThemeData(color: Colors.white),
);
