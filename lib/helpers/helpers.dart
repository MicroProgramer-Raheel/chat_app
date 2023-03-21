import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/message.dart';


var dbInstance = FirebaseFirestore.instance;
CollectionReference usersRef = dbInstance.collection("users");
CollectionReference postsRef = dbInstance.collection("posts");
String placeholder_url = "https://phito.be/wp-content/uploads/2020/01/placeholder.png";
String userPlaceHolder = "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png";
String appName = "Chat";
var uid =auth.FirebaseAuth.instance.currentUser!.uid;
double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}


Future<void> launchUrl(String url) async {
  url = !url.startsWith("http") ? ("http://" + url) : url;
  if (await canLaunch(url)) {
    launch(
      url,
      forceSafariVC: true,
      enableJavaScript: true,
      forceWebView: GetPlatform.isAndroid,
    );
  } else {
    throw 'Could not launch $url';
  }
}
var chatsRef = FirebaseDatabase.instance.ref("chats/");

Future<void> sendMessage(Message message) async {
  await chatsRef.child("${message.sender_id}/inbox/${message.receiver_id}/${message.id}").set(message.toMap());
  await chatsRef.child("${message.receiver_id}/inbox/${message.sender_id}/${message.id}").set(message.toMap()).catchError((error) {
    throw error.toString();
  });
}