import 'package:flutter/material.dart';

class Theme {
  static const Color primary = Color.fromRGBO(52, 58, 79, 1.0);
  static const Color gris1 = Color.fromRGBO(62, 67, 83, 1.0);
  static const Color gris2 = Color.fromARGB(255, 163, 171, 186);
  static const Color gris3 = Color.fromRGBO(207, 207, 207, 1.0);
  static const Color amarillo = Color.fromARGB(255, 243, 202, 99);
  static const Color rojo = Color.fromARGB(255, 225, 113, 113);
  static const Color verde = Color.fromARGB(255, 111, 191, 118);
  static const Color azul = Color.fromARGB(255, 107, 195, 242);
  static const Color morado = Color.fromARGB(255, 132, 89, 137);
  static const Color cafe = Color.fromRGBO(171, 120, 110, 1.0);

  static const TextStyle lblNormal = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: primary,
  );
  static const TextStyle lblNormal2 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.bold,
    color: gris2,
  );
  static const TextStyle lblTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle lblTitlePage = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: primary,
  );
  static const TextStyle lblTitlePage2 = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle lblHomeOption = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const progressIndicator = {
    "message": 'Consultando...',
    "backgroundColor": Theme.gris1,
    "messageTextStyle": TextStyle(
      color: Colors.white,
      fontSize: 19.0,
      fontWeight: FontWeight.w600,
    ),
  };

  static final ThemeData ligthTheme = ThemeData.light().copyWith(
    primaryColor: primary,

    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,

      iconTheme: IconThemeData(color: primary),
    ),
    scaffoldBackgroundColor: Colors.white,

    //textfieldform
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.all(10),
      labelStyle: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: gris2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: gris2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: gris2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: gris2),
      ),
    ),

    //botongral
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.verde,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        minimumSize: const Size(100, 40),
        textStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}
