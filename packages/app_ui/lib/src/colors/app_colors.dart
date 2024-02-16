import 'package:flutter/material.dart';

/// Defines the color palette for the App UI Kit.
abstract class AppColors {
  /// Black
  static const Color black = Color(0xFF000000);

  /// The background color.
  static const Color background = Color.fromARGB(255, 32, 30, 30);

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// Transparent
  static const Color transparent = Color(0x00000000);

  /// The blue primary color and swatch.
  static const Color blue = Color(0xFF3898EC);

  /// The border outline color.
  static const Color borderOutline = Color.fromARGB(45, 250, 250, 250);

  /// Light dark.
  static const Color lightDark = Color.fromARGB(164, 120, 119, 119);

  /// Dark.
  static const Color dark = Color.fromARGB(165, 58, 58, 58);

  /// Grey.
  static const MaterialColor grey = Colors.grey;

  /// The bright grey color.
  static const Color brightGrey = Color.fromARGB(255, 238, 238, 238);

  /// The dark grey color.
  static const Color darkGrey = Color.fromARGB(255, 66, 66, 66);

  /// Red.
  static const MaterialColor red = Colors.red;
}