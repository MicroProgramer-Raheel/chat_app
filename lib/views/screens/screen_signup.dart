import 'package:chat_app/views/screens/screen_home.dart';
import 'package:chat_app/views/screens/screen_signup.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/models/user.dart' as model;
import 'package:chat_app/helpers/helpers.dart';
class ScreenSignup extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Column(
        children: [
          CustomInputField(
            hint: "name",
            controller: nameController,
          ),
          CustomInputField(
            hint: "email",
            controller: emailController,
          ),
          CustomInputField(
            hint: "Password",
            controller: passwordController,
          ),
          TextButton(
              onPressed: () {
                Get.to(ScreenSignup());
              },
              child: Text("log in")),
          CustomButton(
              text: "Sign Up",
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                String name = nameController.text.trim();
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password)
                    .then((value) async{
                  var user = model.User(
                    id: value.user!.uid,
                    name: name,
                    email: email,
                    password: password,
                    timeStamp: DateTime.now().millisecondsSinceEpoch,
                  );
                  await usersRef.doc(user.id).set(user.toMap()).then((value) {
                    Get.to(ScreenHome());
                  }).catchError((onError){
                    Get.snackbar("Alery", onError.toString());
                  });

                });
              })
        ],
      ),
    );
  }
}
