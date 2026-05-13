import 'package:flutter/material.dart';
import 'home.dart';
void main() {
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Persistence',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomAppBarTheme: BottomAppBarThemeData(
          color: Colors.blue,
        ),
      ),
      home: Home(),
    );
  }
}
