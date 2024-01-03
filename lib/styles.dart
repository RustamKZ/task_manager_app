// styles.dart

import 'package:flutter/material.dart';

class AppStyles {
  static final LinearGradient gradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color.fromRGBO(0, 34, 107, 0.89)],
  );
  static final BoxDecoration containerDecoration = BoxDecoration(
    gradient: gradientBackground,
  );

  static final TextStyle buttonTextStyle =
      TextStyle(fontSize: 20, color: Colors.white);

  static final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  );

  static final Color buttonBackgroundColor =
      const Color.fromARGB(255, 95, 114, 223);
}
