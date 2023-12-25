import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/auth.dart';
import '../constants/colors.dart';
import '../models/chat_user.dart';
import '../utils/dialogs.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  //**
  final ChatUser user;

  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //*** form key for validation of text fields ->
  final _formKey = GlobalKey<FormState>();

  //*** for image picker ->
  String? _image;

  @override
  Widget build(BuildContext context) {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      //*** for hiding keyboard when touched anywhere on screen ->
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //?? appbar ->
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Profile Screen',
          ),
        ),

        //?? floating action button for logging out ->
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, right: 6.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            splashColor: Colors.cyan,
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await Auth.auth.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                    (value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout_sharp,
              color: Colors.white,
            ),
            label: const Text(
              'LogOut',
              style: TextStyle(
                fontFamily: 'poppins_medium',
                fontSize: 17.0,
                letterSpacing: 0.8,
                color: Colors.white,
              ),
            ),
          ),
        ),

        //?? body ->
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                children: [
                  //*** for adjusting the image ->
                  SizedBox(width: size.width, height: size.height * 0.03),

                  //?? profile image ->
                  Stack(
                    children: [
                      _image != null
                          ?
                          //?? local image ->
                          ClipRRect(
                              borderRadius: BorderRadius.circular(
                                size.height * .1,
                              ),
                              child: Image.file(
                                File(_image!),
                                width: size.height * .2,
                                height: size.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: CachedNetworkImage(
                                width: size.height * 0.16,
                                height: size.height * 0.16,
                                fit: BoxFit.fill,
                                imageUrl: widget.user.image,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  backgroundColor: appBarColor,
                                  child: Icon(
                                    CupertinoIcons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: -6.0,
                        right: -25.0,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white60,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),

                  //*** for showing email of the user ->
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      fontFamily: 'poppins_medium',
                      fontSize: 18.0,
                      letterSpacing: 0.8,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),

                  //*** for editing name ->
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => Auth.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    style: const TextStyle(
                      fontFamily: 'poppins_bold',
                      fontSize: 16.0,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'eg. Dua Lipa',
                      label: const Text('Name'),
                    ),
                  ),
                  SizedBox(height: size.height * .045),

                  //*** about input field
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => Auth.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    style: const TextStyle(
                      fontFamily: 'poppins_bold',
                      fontSize: 16.0,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.info_outline,
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'eg. Feeling Gay',
                      label: const Text('About'),
                    ),
                  ),

                  SizedBox(height: size.height * .09),

                  //*** for saving changes ->
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Auth.updateUserInfo().then(
                          (value) {
                            Dialogs.showSnackBar(
                              context,
                              'Profile Updated Successfully!!',
                            );
                          },
                        );
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 24.0,
                      color: Colors.orange,
                    ),
                    label: const Text(
                      'UPDATE',
                      style: TextStyle(
                        fontFamily: 'poppins_bold',
                        fontSize: 18.0,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //?? for creating bottom sheet for showing gallery and camera options ->
  void _showBottomSheet() {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: size.height * .03,
            bottom: size.height * .05,
          ),
          children: [
            //*** pick profile picture label ->
            const Text(
              'Pick Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'poppins_bold',
                fontSize: 19.0,
                letterSpacing: 0.8,
                color: Colors.white,
              ),
            ),

            SizedBox(height: size.height * .02),

            //*** buttons (gallery and camera) ->
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //*** pick from gallery button ->
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(
                      size.width * .3,
                      size.height * .15,
                    ),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    //** Pick an image ->
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 80);
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      Auth.updateProfilePicture(File(_image!));

                      //*** for hiding bottom sheet ->
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(
                    'assets/images/gallery.png',
                    width: 70.0,
                    height: 70.0,
                  ),
                ),

                //*** take picture from camera button ->
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(
                      size.width * .3,
                      size.height * .15,
                    ),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    //*** Pick an image ->
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      Auth.updateProfilePicture(File(_image!));
                      //*** for hiding bottom sheet ->
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(
                    'assets/images/camera.png',
                    width: 70.0,
                    height: 70.0,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
