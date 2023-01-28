import 'package:flutter/material.dart';

import '../consts/colors.dart';

class CustomThemes {
  static final lightTheme = ThemeData(
    cardColor: Colors.white,
    fontFamily: "poppins",
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.grey.shade400,
    iconTheme: const IconThemeData(
      color: Colors.grey,
    ),
  );
  static final darkTheme = ThemeData(
    cardColor: bgColor.withOpacity(0.6),
    fontFamily: "poppins",
    scaffoldBackgroundColor: bgColor,
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
