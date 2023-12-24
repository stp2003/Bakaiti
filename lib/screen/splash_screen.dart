import 'package:flutter/material.dart';

import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //*** for animate ->
  bool _isAnimate = false;

  //?? init state ->
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 4),
      () {
        //?? for checking if user is already logged in or not ->
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      },
    );
    Future.delayed(
      const Duration(microseconds: 500),
      () {
        setState(() {
          _isAnimate = true;
        });
      },
    );
  }

  //?? build ->
  @override
  Widget build(BuildContext context) {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    return Scaffold(
      //*** body ->
      body: Stack(
        children: [
          //?? app logo ->
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            top: size.height * 0.15,
            left: _isAnimate ? size.width * 0.25 : -size.width * 0.5,
            width: size.width * 0.5,
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),

          //**
          Positioned(
            bottom: size.height * 0.15,
            width: size.width,
            child: const Text(
              'Welcome to बकैती',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'poppins_bold',
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
