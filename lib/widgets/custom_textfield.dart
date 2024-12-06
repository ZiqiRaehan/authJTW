import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.white70,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF6C63FF),
        ),
        suffixIcon: isPassword
            ? Icon(
                Icons.visibility_outlined,
                color: Colors.white70,
              )
            : null,
      ),
    );
  }
}
