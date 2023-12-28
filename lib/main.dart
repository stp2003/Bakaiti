import 'dart:developer';

import 'package:baikaiti/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

import 'constants/colors.dart';
import 'firebase_options.dart';

void main() async {
  //*** init WidgetsFlutterBinding ->
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //**
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
        (value) async {
      //?? init firebase ->
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      //?? notification channel ->
      var result = await FlutterNotificationChannel.registerNotificationChannel(
        description: 'For Showing Message Notification',
        id: 'chats',
        importance: NotificationImportance.IMPORTANCE_HIGH,
        name: 'Chats',);
      log('\nNotification Channel Result: $result');
      runApp(const MyApp());
    },
  );
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
      home: const SplashScreen(),
    );
  }
}
