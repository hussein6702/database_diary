import 'package:database_diary/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Storage',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
