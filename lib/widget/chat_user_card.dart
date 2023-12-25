import 'package:baikaiti/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: 5.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: cardColor,
      elevation: 15.0,
      child: InkWell(
        splashColor: Colors.lightGreen,
        onTap: () {},
        child: ListTile(
          //?? for profile pic ->
          leading: const CircleAvatar(
            backgroundColor: appBarColor,
            child: Icon(
              CupertinoIcons.person,
              color: Colors.white,
            ),
          ),

          //?? for name of user ->
          title: Text(
            widget.user.name,
            style: const TextStyle(
              fontFamily: 'poppins_bold',
              fontSize: 16.0,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),

          //?? for last message ->
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
            style: const TextStyle(
              fontFamily: 'poppins_medium',
              fontSize: 14.0,
              letterSpacing: 0.8,
              color: Colors.white70,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          //?? for last message time sent ->
          trailing: const Text(
            '12.00 AM',
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 14.0,
              letterSpacing: 0.8,
              color: Colors.white60,
            ),
          ),
        ),
      ),
    );
  }
}
