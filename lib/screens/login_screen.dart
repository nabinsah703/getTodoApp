// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gettodoapp/model/google_user.dart';
import 'package:gettodoapp/screens/forget_password.dart';
import 'package:gettodoapp/screens/home_screen.dart';
import 'package:gettodoapp/screens/sign_up_screen.dart';
import 'package:gettodoapp/services/google_sign_in_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  bool isResult = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String signInText = "You are not currently signed in.";
  String errorText = "";

  FirebaseFirestore fbStore = FirebaseFirestore.instance;
  GoogleUser? _googleUser;

  @override
  void initState() {
    super.initState();
    GoogleSignInUser.auth.authStateChanges().listen((data) {
      if (data != null) {
        signInSignUp(data);
      } else {
        _googleUser = null;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      label: Text("Email"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: "Enter Email ID"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your Email ID ';
                    } else if (!value.contains('@')) {
                      return 'Enter valid Email Address';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      label: Text("Password"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: "Enter password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't blank";
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login(emailController.text, passwordController.text);
                        }
                      },
                      child: const Text(
                        "Login",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const SignUpScreen());
                      },
                      child: const Text(
                        "Sign Up",
                      ),
                    ),
                    ElevatedButton(
                      child: const Text("Forget Password"),
                      onPressed: () {
                        Get.to(() => const ForgetPassword());
                      },
                    )
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  label: const Text("Sign In With Google Account"),
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      GoogleSignInUser.signInWithGoogle(context: context);
      Get.to(
        () => _googleUser != null ? const HomeScreen() : const LoginScreen(),
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        error.toString(),
      );
    }
  }

  void signInSignUp(User? currentUser) {
    if (currentUser != null) {
      DocumentReference userRef = fbStore.collection('users').doc(currentUser.uid);
      userRef.get().then((docSnapShot) {
        if (docSnapShot.exists) {
          Map<String, dynamic>? data = docSnapShot.data() as Map<String, dynamic>?;

          GoogleUser googleUserL =
              GoogleUser(id: docSnapShot.id, displayName: data?['displayName'], email: data?['email']);

          setState(() {
            _googleUser = googleUserL;
          });
          userRef.set(_googleUser!.toJson(), SetOptions(merge: true));
        } else {
          GoogleUser googleUserL = GoogleUser(
            id: currentUser.uid,
            displayName: currentUser.displayName!,
            email: currentUser.email!,
          );

          setState(() {
            _googleUser = googleUserL;
          });
          userRef.set(_googleUser!.toJson(), SetOptions(merge: true));
        }
      }, onError: (error) {
        setState(() {
          signInText = error.message.toString();
        });
      });
    }
  }

  void login(String email, String password) async {
    try {
      if (await userSign(email, password)) {
        Get.to(()=>const HomeScreen());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logging successfully"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email Address or Password is wrong"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> userSign(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      isResult = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No user found for that email."),
          ),
        );
        print('No user found for that email.');
      }
    }
    return isResult;
  }
}
