import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../auth/auth.dart';
import '../constants/colors.dart';
import '../models/message.dart';
import '../utils/dialogs.dart';
import '../utils/my_date_util.dart';
import 'option_item.dart';

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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    bool isMe = Auth.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
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
                  ? size.width * .02
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
                  ? size.width * .02
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

  //?? bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    //*** media query ->
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      backgroundColor: appBarColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: size.height * .015,
                horizontal: size.width * .4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            widget.message.type == Type.text
                ?
                //?? copy option
                OptionItem(
                    icon: const Icon(
                      Icons.copy_all_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.message.msg),
                      ).then(
                        (value) {
                          Navigator.pop(context);
                          Dialogs.showSnackBar(context, 'Text Copied!');
                        },
                      );
                    },
                  )
                :
                //?? save option
                OptionItem(
                    icon: const Icon(
                      Icons.download_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Save Image',
                    onTap: () async {
                      try {
                        log('Image Url: ${widget.message.msg}');
                        await GallerySaver.saveImage(
                          widget.message.msg,
                          albumName: 'बकैती',
                        ).then(
                          (success) {
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackBar(
                                context,
                                'Image Successfully Saved!',
                              );
                            }
                          },
                        );
                      } catch (e) {
                        log('ErrorWhileSavingImg: $e');
                      }
                    },
                  ),

            //?? separator or divider
            if (isMe)
              Divider(
                color: Colors.black54,
                endIndent: size.width * .04,
                indent: size.width * .04,
              ),

            //?? edit option
            if (widget.message.type == Type.text && isMe)
              OptionItem(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                name: 'Edit Message',
                onTap: () {
                  Navigator.pop(context);
                  _showMessageUpdateDialog();
                },
              ),

            //?? delete option
            if (isMe)
              OptionItem(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 26,
                ),
                name: 'Delete Message',
                onTap: () async {
                  await Auth.deleteMessage(widget.message).then(
                    (value) {
                      Navigator.pop(context);
                    },
                  );
                },
              ),

            //?? separator or divider
            Divider(
              color: Colors.black54,
              endIndent: size.width * .04,
              indent: size.width * .04,
            ),

            //sent time
            OptionItem(
              icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
              name:
                  'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
              onTap: () {},
            ),

            //?? read time
            OptionItem(
              icon: const Icon(Icons.remove_red_eye, color: Colors.green),
              name: widget.message.read.isEmpty
                  ? 'Read At: Not seen yet'
                  : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  //?? dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.message,
              color: Colors.blue,
              size: 28,
            ),
            Text(' Update Message')
          ],
        ),
        content: TextFormField(
          initialValue: updatedMsg,
          maxLines: null,
          onChanged: (value) => updatedMsg = value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Auth.updateMessage(widget.message, updatedMsg);
              if (mounted) {
                navigatorKey.currentState?.pop();
              }
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
