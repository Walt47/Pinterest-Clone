import 'package:flutter/material.dart';
import 'package:pinterest/loginscreen.dart';
import 'dart:async';
import 'package:pinterest/selectorscreen.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        opacity = 1.0;
      });
    });

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(), //const SelectorScreen()
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: 1 - opacity,
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                'images/pinterest_logo.png',
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
