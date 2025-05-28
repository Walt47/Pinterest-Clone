import 'package:flutter/material.dart';
import 'package:pinterest/titlescreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pinterest',
        debugShowCheckedModeBanner: false,
        home: TitleScreen());
  }
}
