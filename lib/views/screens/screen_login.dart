import 'package:chat_app/views/screens/screen_home.dart';
import 'package:chat_app/views/screens/screen_signup.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenLogin extends StatelessWidget {
TextEditingController emailController=TextEditingController();
TextEditingController passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login")
        ,
      ),
      body: Column(children: [
        CustomInputField(
          hint: "email",
        controller: emailController,
        ),
        CustomInputField(
          hint: "Password",
          controller: passwordController,
        ),
        TextButton(onPressed: (){
          Get.to(ScreenSignup());
        }, child: Text("SignUp")),
        CustomButton(text: "Login", onPressed: ()async{
          String email=emailController.text.trim();
          String password=passwordController.text.trim();
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
            Get.to(ScreenHome());
          });
        })
      ],),
    );
  }
}
