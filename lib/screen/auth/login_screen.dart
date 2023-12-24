import 'dart:developer';
import 'dart:io';

import 'package:baikaiti/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../auth/auth.dart';
import '../../utils/dialogs.dart';

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

  //?? to handle google sign in button ->
  _handleGoogleBtnClick() {
    //*** for showing progress abr ->
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then(
      (user) async {
        //*** for hiding progress bar ->
        Navigator.pop(context);

        if (user != null) {
          log('\nUser: ${user.user}');
          log('\nAdditional User: ${user.additionalUserInfo}');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
        }
      },
    );
  }

  //?? to handle google sign in ->
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Auth.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackBar(context, 'Something went wrong(Please wait)');
      return null;
    }
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
                _handleGoogleBtnClick();
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
