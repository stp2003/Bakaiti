import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../auth/auth.dart';
import '../constants/colors.dart';
import '../models/message.dart';
import '../utils/my_date_util.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Auth.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  //?? sender or other user message ->
  Widget _blueMessage() {
    //*** media query ->
    final size = MediaQuery.of(context).size;
    //*** update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      Auth.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              widget.message.type == Type.image
                  ? size.width * .015
                  : size.width * .04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: size.width * .04,
              vertical: size.height * .01,
            ),
            decoration: BoxDecoration(
              color: blueColorField,
              border: Border.all(color: floatingActionButtonColor),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(
                      fontFamily: 'poppins_bold',
                      fontSize: 14.0,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),

        //?? for showing time ->
        Padding(
          padding: EdgeInsets.only(right: size.width * 0.04),
          child: Text(
            MyDateUtil.getFormattedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: const TextStyle(
              fontFamily: 'poppins_medium',
              fontSize: 11.0,
              letterSpacing: 0.8,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  //?? reciever or your message ->
  Widget _greenMessage() {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //?? for showing time ->
        Row(
          children: [
            SizedBox(
              width: size.width * 0.04,
            ),
            //*** for blue tick ->
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_sharp,
                color: Colors.blue,
                size: 20.0,
              ),
            const SizedBox(width: 5.0),
            //*** for read time ->
            Text(
              MyDateUtil.getFormattedTime(
                context: context,
                time: widget.message.sent,
              ),
              style: const TextStyle(
                fontFamily: 'poppins_medium',
                fontSize: 11.0,
                letterSpacing: 0.8,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        //?? for showing messages ->
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              widget.message.type == Type.image
                  ? size.width * .015
                  : size.width * .04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: size.width * .04,
              vertical: size.height * .01,
            ),
            decoration: BoxDecoration(
              color: greenColorField,
              border: Border.all(color: Colors.greenAccent),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(
                      fontFamily: 'poppins_bold',
                      fontSize: 14.0,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
