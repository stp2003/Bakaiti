import 'package:baikaiti/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../screen/chat_screen.dart';

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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                user: widget.user,
              ),
            ),
          );
        },
        child: ListTile(
          //?? for profile pic ->
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
              width: size.height * 0.055,
              height: size.height * 0.055,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => const CircleAvatar(
                backgroundColor: appBarColor,
                child: Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
              ),
              fit: BoxFit.cover,
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
          trailing: Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
