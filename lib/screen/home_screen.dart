import 'package:baikaiti/auth/auth.dart';
import 'package:baikaiti/widget/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/colors.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
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
          body: StreamBuilder(
            stream: Auth.firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              //*** for checking connection state ->
              switch (snapshot.connectionState) {
                //*** if data is loading ->
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                //*** if data loaded ->
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                      itemCount: list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: list[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No Connections Found!!',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
