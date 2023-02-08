import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:gettodoapp/screens/login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var email = emailController.text.trim();
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) => {
                      print("Email sent!!"),
                      Get.off(
                        () => LoginScreen(),
                      ),
                    });
              } on FirebaseAuthException catch (e) {
                print("Error $e");
              }
            },
            child: const Text(
              "Submit",
            ),
          )
        ],
      ),
    );
  }
}
