import 'dart:ffi';
import 'dart:io';

import 'package:firebasetest/screens/home_screen.dart';
import 'package:firebasetest/screens/login_screen.dart';
import 'package:firebasetest/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Icon(
        Icons.account_balance,
        color: Colors.blue,
        size: 150,
      )),
    );
  }

  void navigateToScreen(BuildContext context) async {
    bool? isUserLoggedIn =
        await SharedPreferencesService.getBoolFromSharedPreferences(
            'user_logged_in');

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => isUserLoggedIn != null
                ? (isUserLoggedIn ? HomeScreen() : LoginScreen())
                : LoginScreen()),
        ModalRoute.withName('/'),
      );
    });
  }
}
