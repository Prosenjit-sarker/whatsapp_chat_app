import 'package:flutter/material.dart';
import '../theme.dart';

class FirebaseErrorScreen extends StatelessWidget {
  const FirebaseErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 72,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Firebase Not Configured',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'The app could not connect to Firebase. Make sure:\n\n'
                '1. Firebase project is set up\n'
                '2. Internet connection is available\n'
                '3. The app has internet permissions\n\n'
                'Try restarting the app.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.subtitleGrey, height: 1.6),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Restart app
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
