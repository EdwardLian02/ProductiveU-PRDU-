import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productive_u/provider/auth_service_provider.dart';
import 'package:productive_u/view/components/custom_button.dart';
import 'package:productive_u/view/components/custom_floating_textfield.dart';
import 'package:productive_u/view/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authSerivceProvider = AuthServiceProvider();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(context) async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
      try {
        await authSerivceProvider.loginUser(
            email: _emailController.text, password: _passwordController.text);

        //navigate back to auth screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          'auth/',
          (Route<dynamic> route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success: Login Success'),
            backgroundColor: Colors.green,
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                    'Welcome back!',
                    style: AppTheme.subheading,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get in and be productive',
                    style: AppTheme.body,
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
                    controller: _emailController,
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
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  CustomFloatingTextfield(
                    label: "Password",
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Log in",
                    onPressed: () => _login(context),
                    width: double.infinity,
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
