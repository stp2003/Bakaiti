import 'package:flutter/material.dart';

import '../constants/colors.dart';

class Dialogs {
  //?? for showing snack bar ->
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: cardColor,
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'poppins',
            fontSize: 15.0,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  //?? for showing progress bar ->
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
