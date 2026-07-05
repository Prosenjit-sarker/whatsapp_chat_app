import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  runApp(const WhatsAppCloneApp());
}

class WhatsAppCloneApp extends StatelessWidget {
  const WhatsAppCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova Chat',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}
