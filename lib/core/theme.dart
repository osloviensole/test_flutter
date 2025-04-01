import 'package:flutter/material.dart';

final ThemeData gamThemeData = ThemeData(
  // Schéma de couleurs principal
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF002E6D),   // Bleu profond
    onPrimary: Colors.white,            // Texte sur fond bleu
    secondary: const Color(0xFFFFD700), // Jaune/or
    onSecondary: Colors.black,          // Texte sur fond jaune
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),

  // Couleur de l'appBar, des boutons, etc. si tu utilises le Material 2 (legacy)
  primaryColor: const Color(0xFF002E6D),
  scaffoldBackgroundColor: Colors.white,

  // Style de l'AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF002E6D),
    foregroundColor: Colors.white, // Couleur du texte/titre
    elevation: 0,
  ),

  // Style du FloatingActionButton
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFD700),
    foregroundColor: Colors.black,
  ),

  // Style des boutons TextButton / ElevatedButton / OutlinedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF002E6D),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF002E6D),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF002E6D),
      side: const BorderSide(color: Color(0xFF002E6D)),
    ),
  ),

  // Thème de la BottomNavigationBar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFFFFD700),
    unselectedItemColor: Colors.grey,
    backgroundColor: Colors.white,
  ),

  textTheme: const TextTheme(

    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF002E6D),
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.black54,
    ),
  ),

);
