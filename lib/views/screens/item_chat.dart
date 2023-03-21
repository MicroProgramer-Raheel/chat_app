import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:custom_utils/custom_utils.dart';

import '../../../models/message.dart';
class ItemChat extends StatelessWidget {
  Message message;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sender_id == uid ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: message.sender_id == uid ?MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              minWidth:MediaQuery.of(context).size.width * 0.1,
              // maxHeight: MediaQuery.of(context).size.width * 0.5,
              // minHeight: 40
            ),
              // width: MediaQuery.of(context).size.width * 0.7,
              margin: EdgeInsets.all(10),
              //height: 40,
              padding: EdgeInsets.only(top: 3, left: 5, right: 5, bottom: 4),
              decoration: BoxDecoration(
                  color: message.sender_id == uid ? appPrimaryColor : Color(0XFFD7D7D7),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                        color:message.sender_id == uid ? Colors.white: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        timestampToDateFormat(message.timestamp, "hh:mm - dd/MM/yyyy"),
                        style: TextStyle(
                            color: message.sender_id == uid ? Colors.white:Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.w400),
                      )),
                ],
              )),
        ],
      ),
    );
  }

  ItemChat({
    required this.message,
  });
}
