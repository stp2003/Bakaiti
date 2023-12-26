import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat_user.dart';
import '../models/message.dart';

class Auth {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //?? to return current user ->
  static User get user => auth.currentUser!;

  //*** me variable ->
  static late ChatUser me;

  //?? for checking if user exists or not ->
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //?? for creating new user ->
  static Future<void> createUsers() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using बकैती!",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return await firestore.collection('users').doc(user.uid).set(
          chatUser.toJson(),
        );
  }

  //?? get all users->
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //?? for getting user info for profile section ->
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then(
      (user) async {
        if (user.exists) {
          me = ChatUser.fromJson(user.data()!);
        } else {
          await createUsers().then((value) => getSelfInfo());
        }
      },
    );
  }

  //?? for updating user name and about ->
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update(
      {
        'name': me.name,
        'about': me.about,
      },
    );
  }

  //?? update profile picture of user ->
  static Future<void> updateProfilePicture(File file) async {
    //*** getting image file extension ->
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //*** storage file ref with path ->
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //*** uploading image ->
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
      (p0) {
        log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
      },
    );

    //*** updating image in firestore database ->
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update(
      {
        'image': me.image,
      },
    );
  }

  //!! ------------------------------------------------------------------------------------------------------------------------------------

  //?? useful for getting conversation id ->
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //?? for getting all messages ->
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUser user,
  ) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: false)
        .snapshots();
  }

  //?? for sending message ->
  static Future<void> sendMessage(
    ChatUser chatUser,
    String msg,
  ) async {
    //*** message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //*** message to send
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: Type.text,
      fromId: user.uid,
      sent: time,
    );

    final ref = firestore.collection(
      'chats/${getConversationID(chatUser.id)}/messages/',
    );
    await ref.doc(time).set(message.toJson());
  }
}
