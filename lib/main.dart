import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/firebase_error_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const WhatsAppCloneApp());
}

class WhatsAppCloneApp extends StatefulWidget {
  const WhatsAppCloneApp({super.key});

  @override
  State<WhatsAppCloneApp> createState() => _WhatsAppCloneAppState();
}

class _WhatsAppCloneAppState extends State<WhatsAppCloneApp> {
  bool _hasSession = false;
  bool _firebaseInitialized = false;
  bool _checkComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Check if Firebase is initialized
    _firebaseInitialized = Firebase.apps.isNotEmpty;

    // Load session only if Firebase is ready
    if (_firebaseInitialized) {
      final session = await AuthService.getSession();
      if (!mounted) return;
      setState(() {
        _hasSession = session['phone']?.isNotEmpty == true && session['name']?.isNotEmpty == true;
        _checkComplete = true;
      });
    } else {
      if (mounted) {
        setState(() {
          _checkComplete = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkComplete) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (!_firebaseInitialized) {
      return MaterialApp(
        title: 'Nova Chat',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const FirebaseErrorScreen(),
      );
    }

    return MaterialApp(
      title: 'Nova Chat',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: _hasSession ? const HomeScreen() : const LoginScreen(),
    );
  }
}
