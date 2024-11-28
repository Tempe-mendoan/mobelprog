import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MasakYukApp());
}

class MasakYukApp extends StatelessWidget {
  const MasakYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masak Yuk!',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
