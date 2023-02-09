// ignore_for_file: avoid_print, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gettodoapp/screens/login_screen.dart';

class ForgetPassword extends StatelessWidget {
   ForgetPassword({super.key});

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                label: Text("Email"),
                hintText: "Enter Email Address",
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
                        Get.snackbar("send","Password reset is send successfully",
                        snackPosition: SnackPosition.BOTTOM),
                        Get.offAll(
                          () => const LoginScreen(),
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
      ),
    );
  }
}
