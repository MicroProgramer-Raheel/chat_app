import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/user.dart' as model;
import 'package:get/get.dart';

import '../../helpers/fcm.dart';
import '../../helpers/helpers.dart';
import '../../models/message.dart';
import 'item_chat.dart';

class ScreenChat extends StatelessWidget {


  ScreenChat({
    required this.user,
  });

  model.User user;

   var messageController = TextEditingController();
   @override
   Widget build(BuildContext context) {
     return SafeArea(
       child: Scaffold(
         appBar: AppBar(
           automaticallyImplyLeading: false,
           backgroundColor: Colors.white,
           elevation: 1,
           title:Text(user.name),
         ),
         body:Column(children: [
           Expanded(
             child: StreamBuilder<DocumentSnapshot>(
               stream: usersRef.doc(user.id).snapshots(),
               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                 if (snapshot.connectionState==ConnectionState.waiting) {
                   return CircularProgressIndicator();
                 }  
                 var user=model.User.fromMap(snapshot.data.data() as Map<String,dynamic>);
               return StreamBuilder<DatabaseEvent>(
                   stream: chatsRef.child("$uid/inbox/${user.id}").onValue,
                   builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return CupertinoActivityIndicator();
                     }
                     var messages = snapshot.data!.snapshot.children.map((e) => Message.fromMap(Map<String, dynamic>.from(e.value as dynamic))).toList();

                     return messages.isNotEmpty
                         ? SingleChildScrollView(
                       child: Column(
                         children: messages
                             .map((e) => ItemChat(message: e))
                             .toList(),
                       ),
                     )
                         : NotFound(message: "LocaleKeys.NoMessages.tr");
                   });
             },)
           ),
           Row(
             children: <Widget>[
               Expanded(child: CustomInputField(
                 showBorder: true,
                 controller: messageController,
                 margin: EdgeInsets.only(left: 8.sp),
                 hint: "LocaleKeys.TypeHere.tr",
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10)),
                   borderSide: BorderSide(width: 1, color: hintColor),
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10)),
                   borderSide: BorderSide(width: 1, color: hintColor),
                 ),
                 // focuseBorder: OutlineInputBorder(
                 //   borderRadius: BorderRadius.all(Radius.circular(10)),
                 //   borderSide: BorderSide(width: 1, color: hintColor),
                 // ),
               )),
               Container(
                   margin: EdgeInsets.all(5.sp),
                   decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: Colors.white),
                   child: IconButton(onPressed: (){
                     String text = messageController.text.trim();
                     if (text.isNotEmpty) {
                       var timestamp = DateTime.now().millisecondsSinceEpoch;
                       var message = Message(
                           id: timestamp.toString(),
                           timestamp: timestamp,
                           text: text,
                           sender_id: uid,
                           receiver_id: user!.id,
                           message_type: "text");
                       messageController.clear();
                       sendMessage(message).catchError((error) {
                         Get.snackbar("LocaleKeys.Alert.tr", error.toString());
                       });
                     }
                   }, icon: Icon(Icons.send)))
             ],
           ),
         ],)
       ),
     );


}
}
