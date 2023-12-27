import 'package:baikaiti/auth/auth.dart';
import 'package:baikaiti/models/chat_user.dart';
import 'package:baikaiti/widget/profile_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/message.dart';
import '../screen/chat_screen.dart';
import '../utils/my_date_util.dart';

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
  Message? _message;

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
        child: StreamBuilder(
          stream: Auth.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              //*** user profile picture
              leading: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ProfileDialog(user: widget.user),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    width: size.height * .055,
                    height: size.height * .055,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //*** user name
              title: Text(
                widget.user.name,
                style: const TextStyle(
                  fontFamily: 'poppins_bold',
                  fontSize: 16.0,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),

              //*** last message
              subtitle: Text(
                _message != null
                    ? _message!.type == Type.image
                        ? 'image'
                        : _message!.msg
                    : widget.user.about,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'poppins_medium',
                  fontSize: 14.0,
                  letterSpacing: 0.8,
                  color: Colors.white70,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              //*** last message time
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.fromId != Auth.user.uid
                      ?
                      //*** show for unread message
                      Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      :
                      //*** message sent time
                      Text(
                          MyDateUtil.getLastMessageTime(
                            context: context,
                            time: _message!.sent,
                          ),
                          style: const TextStyle(color: Colors.white54),
                        ),
            );
          },
        ),
      ),
    );
  }
}
