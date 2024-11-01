import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Field extends StatelessWidget {
  const Field({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CustomTextField extends StatelessWidget {
  final String text1;
  final TextEditingController controller;
  final bool? obscureText;
  final double wdt;
  const CustomTextField({
    super.key,
    required this.text1,
    required this.controller,
    this.obscureText = false,
    required this.wdt
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: wdt,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              style: GoogleFonts.jost(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              obscureText: obscureText!,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ));
  }
}
