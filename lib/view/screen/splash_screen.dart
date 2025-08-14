import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productive_u/view/components/auth_option_tile.dart';
import 'package:productive_u/view/components/custom_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PRODU',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/app-logo.png',
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 60),
              CustomButton(
                text: "Log in",
                onPressed: () => Navigator.pushNamed(context, 'login/'),
                elevation: 0,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Sign up",
                onPressed: () => Navigator.pushNamed(context, 'signup/'),
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
