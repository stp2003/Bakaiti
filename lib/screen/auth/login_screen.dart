import 'package:baikaiti/screen/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //*** for animate ->
  bool _isAnimate = false;

  //?? init state ->
  @override
  void initState() {
    super.initState();

    //*** for animation on logo ->
    Future.delayed(
      const Duration(microseconds: 500),
      () {
        setState(() {
          _isAnimate = true;
        });
      },
    );
  }

  //?? build- >
  @override
  Widget build(BuildContext context) {
    //*** media query ->
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Welcome to बकैती',
        ),
      ),

      //?? body ->
      body: Stack(
        children: [
          //?? app logo ->
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            top: size.height * 0.15,
            right: _isAnimate ? size.width * 0.25 : -size.width * 0.5,
            width: size.width * 0.5,
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),

          //?? button for google sign- in ->
          Positioned(
            bottom: size.height * 0.15,
            left: size.width * 0.05,
            width: size.width * 0.9,
            height: size.height * 0.0656,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: 35.0,
                width: 35.0,
              ),
              label: const Text(
                '  Log-In with Google',
                style: TextStyle(
                  fontFamily: 'poppins_bold',
                  fontSize: 18.0,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),

              //?? styling the elevated button ->
              style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: Colors.cyan[210],
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
