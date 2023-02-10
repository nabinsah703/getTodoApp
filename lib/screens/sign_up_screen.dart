import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gettodoapp/screens/login_screen.dart';

import '../controller/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

AuthController authController = Get.put(AuthController()); 
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _signUpKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Form(
        key: _signUpKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    } else if (!value.contains('@')) {
                      return 'Please Enter Valid Email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      labelText: "Enter Your Email ID")),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Enter your password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                obscureText: true,
                controller: confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Confirm password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    )),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_signUpKey.currentState!.validate()) {
                  authController.registration(emailController.text, passwordController.text, confirmPasswordController.text);
                  }
                },
                child: const Text(
                  "Sign Up",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('If you have Already account? '),
                  InkWell(
                    onTap: () {
                      Get.offAll(() => LoginScreen());
                    },
                    child: const Text(
                      "sign in",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
