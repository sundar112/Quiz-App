
import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MCQ Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // Load HomeScreen directly
    );
  }
}
