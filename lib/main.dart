import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cuisine_mada/firebase_options.dart';
import 'package:cuisine_mada/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CuisineMadaApp());
}