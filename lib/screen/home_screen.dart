import 'package:baikaiti/widget/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          //?? appbar ->
          appBar: AppBar(
            centerTitle: true,
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    style: const TextStyle(
                      fontFamily: 'poppins_medium',
                      fontSize: 15.0,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'eg. Dua Lipa',
                      label: Text('Search'),
                    ),
                    autofocus: true,

                    //?? for updating the search list when it's changed ->
                    onChanged: (val) {},
                  )
                : const Text(
                    'बकैती',
                    style: TextStyle(
                      fontFamily: 'poppins_bold',
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled
                      : Icons.search_sharp,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_sharp,
                ),
              ),
            ],
          ),

          //?? floating action button for adding members ->
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 6.0),
            child: FloatingActionButton(
              backgroundColor: floatingActionButtonColor,
              splashColor: Colors.cyan,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(
                Icons.add_comment_outlined,
                color: Colors.white,
              ),
            ),
          ),

          //?? body ->
          body: ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: size.height * 0.01),
            itemBuilder: (context, index) {
              return const ChatUserCard();
            },
          ),
        ),
      ),
    );
  }
}
