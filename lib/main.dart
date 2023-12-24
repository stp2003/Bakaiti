import 'package:baikaiti/screen/auth/home_screen.dart';
import 'package:flutter/material.dart';

import 'constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,

        //*** customizing app bar ->
        appBarTheme: const AppBarTheme(
          color: appBarColor,
          elevation: 1.0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontFamily: 'poppins_bold',
            fontSize: 18.0,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
