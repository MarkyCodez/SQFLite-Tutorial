import 'package:flutter/material.dart';
import 'package:sqflite_tutorial/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQFLite Tutorial',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
