import 'package:flutter/material.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('Profil 👤',
          style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800)),
      ),
    );
  }
}