import 'package:flutter/material.dart';
import 'package:productive_u/view/theme.dart';

class CustomFloatingTextfield extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final bool autofocus;
  final TextInputAction? textInputAction;

  const CustomFloatingTextfield({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.errorText,
    this.validator,
    this.autofocus = false,
    this.textInputAction,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      autofocus: autofocus,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.boldbackground,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        suffixIcon: suffixIcon,
        errorText: errorText,
        labelStyle: TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
