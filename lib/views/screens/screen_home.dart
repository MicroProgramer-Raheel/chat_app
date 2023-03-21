import 'package:chat_app/helpers/helpers.dart';
import 'package:chat_app/views/screens/screen_chat.dart';
import 'package:chat_app/views/screens/screen_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/models/user.dart' as model;
class ScreenHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Get.offAll(ScreenLogin());

          }, icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.where("id",isNotEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var users=snapshot.data!.docs.map((e) =>model.User.fromMap(e.data() as Map<String,dynamic>)).toList();
          return CustomListviewBuilder( itemCount: users.length,
            scrollDirection: CustomDirection.vertical,
            itemBuilder: (BuildContext context, int index) {
            var user =users[index];
            return ListTile(
              onTap: (){
                Get.to(ScreenChat(user: user,));
              },
              title: Text(user.name),
            );
          },);
        }
      ),
    );
  }
}
