import 'package:flutter/material.dart';
import 'dart:async';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, _navigateToLogin);
  }

  _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories,
              size: 100.0,
              color: colorScheme.onPrimary,
            ),
            const SizedBox(height: 20.0),
            
            Text(
              'Library App',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),

            Text(
              'Akses bacaan favorit Anda',
              style: TextStyle(
                color: colorScheme.onPrimary.withOpacity(0.8),
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 50.0),

            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}