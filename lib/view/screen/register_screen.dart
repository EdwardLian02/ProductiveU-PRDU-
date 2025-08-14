import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:productive_u/provider/auth_service_provider.dart';
import 'package:productive_u/view/components/custom_button.dart';
import 'package:productive_u/view/components/custom_floating_textfield.dart';
import 'package:productive_u/view/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthServiceProvider authServiceProvider = AuthServiceProvider();

  void _register(context) async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
      try {
        await authServiceProvider.registerUser(
            email: emailController.text, password: passwordController.text);

        //navigate back to auth screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          'auth/',
          (Route<dynamic> route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successed!'),
            backgroundColor: Colors.green,
          ),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                e.message ?? "Something went wrong! Please try again later"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleGoogleSignIn(context) async {
    final userCredential = await authServiceProvider.signInWithGoogle();
    _showLoadingDialog();
    if (userCredential != null) {
      final user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Success: Welcome, ${user?.displayName ?? "User"}!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
          context, 'auth/', (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Google sign-in failed. Please try again.')),
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hello, new here?',
                    style: AppTheme.subheading,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please register your account here and be productive!',
                    style: AppTheme.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/app-logo.png',
                    height: 120,
                    width: 150,
                  ),
                  const SizedBox(height: 40),
                  CustomFloatingTextfield(
                    label: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomFloatingTextfield(
                    label: "Password",
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomFloatingTextfield(
                    label: "Confirm Password",
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Sign up",
                    onPressed: () => _register(context),
                    width: double.infinity,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SignInButton(
                    elevation: 0.9,
                    Buttons.Google,
                    text: "Continue with Google",
                    onPressed: () => _handleGoogleSignIn(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
