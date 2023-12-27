import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/auth.dart';
import '../constants/colors.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widget/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list = [];
  final textController = TextEditingController();

  bool showEmoji = false;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (showEmoji) {
              setState(() => showEmoji = !showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: messageScreenColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            //?? body ->
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: Auth.getAllMessages(widget.user),
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
                          list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (list.isNotEmpty) {
                            return ListView.builder(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 8.0),
                              itemCount: list.length,
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: list[index],
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hi 👋',
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
                if (isUploading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                _chatInput(),
                if (showEmoji)
                  SizedBox(
                    height: size.height * .35,
                    child: EmojiPicker(
                      textEditingController: textController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 49, 31, 62),
                        iconColor: Colors.white,
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //?? custom app bar ->
  Widget _appBar() {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {},
      splashColor: Colors.orange,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8.0),
          ClipRRect(
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
          const SizedBox(width: 15.0),

          //?? for user name ->
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontFamily: 'poppins_bold',
                  fontSize: 16.0,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4.0),

              //?? for last seen ->
              const Text(
                'last seen not available',
                style: TextStyle(
                  fontFamily: 'poppins_medium',
                  fontSize: 12.0,
                  letterSpacing: 0.8,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //?? bottom chat input field ->
  Widget _chatInput() {
    //*** media query ->
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * .01,
        horizontal: size.width * .025,
      ),
      child: Row(
        children: [
          //*** input field & buttons ->
          Expanded(
            child: Card(
              color: textFieldColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  //*** emoji button ->
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => showEmoji = !showEmoji);
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_sharp,
                      color: Colors.white70,
                      size: 25.0,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(
                        fontFamily: 'poppins_medium',
                        fontSize: 15.0,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (showEmoji) setState(() => showEmoji = !showEmoji);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Likho Kuch...',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //*** pick image from gallery button ->
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      for (var i in images) {
                        log('Image Path: ${i.path}');
                        setState(() => isUploading = true);

                        await Auth.sendChatImage(widget.user, File(i.path));
                        setState(() => isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white70,
                      size: 26.0,
                    ),
                  ),
                  //*** take image from camera button ->
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 70,
                      );
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() => isUploading = true);

                        await Auth.sendChatImage(widget.user, File(image.path));
                        setState(() => isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_sharp,
                      color: Colors.white70,
                      size: 26.0,
                    ),
                  ),
                  SizedBox(width: size.width * .02),
                ],
              ),
            ),
          ),
          //*** send message button ->
          MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Auth.sendMessage(widget.user, textController.text, Type.text);
                textController.text = '';
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              right: 5.0,
              left: 10.0,
            ),
            shape: const CircleBorder(),
            color: floatingActionButtonColor,
            child: const Icon(
              Icons.send_sharp,
              color: Colors.white,
              size: 28.0,
            ),
          ),
        ],
      ),
    );
  }
}
