import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gettodoapp/controller/login_controller.dart';
import 'package:gettodoapp/model/google_user.dart';
import 'package:gettodoapp/screens/forget_password.dart';
import 'package:gettodoapp/screens/sign_up_screen.dart';
import 'package:gettodoapp/controller/google_sign_in_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final Logincontroller logincontroller = Get.put(Logincontroller());

  final _formKey = GlobalKey<FormState>();

  bool isResult = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String signInText = "You are not currently signed in.";

  FirebaseFirestore fbStore = FirebaseFirestore.instance;

  @override
  void initState() {
    GoogleSignInUser.auth.authStateChanges().listen((data) {
      if (data != null) {
        signInSignUp(data);
      } else {
        logincontroller.user = null;
      }
    });
    super.initState();
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
                    } else if (!value.contains(
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                    )) {
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
                          logincontroller.login(emailController.text, passwordController.text);
                        }
                      },
                      child: const Text(
                        "Login",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => SignUpScreen());
                      },
                      child: const Text(
                        "Sign Up",
                      ),
                    ),
                    ElevatedButton(
                      child: const Text("Forget Password"),
                      onPressed: () {
                        Get.to(() => ForgetPassword());
                      },
                    )
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: logincontroller.handleGoogleSignIn,
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

  void signInSignUp(User? currentUser) {
    if (currentUser != null) {
      DocumentReference userRef = fbStore.collection('users').doc(currentUser.uid);
      userRef.get().then((docSnapShot) {
        if (docSnapShot.exists) {
          Map<String, dynamic>? data = docSnapShot.data() as Map<String, dynamic>?;

          GoogleUser googleUserL =
              GoogleUser(id: docSnapShot.id, displayName: data?['displayName'], email: data?['email']);
          logincontroller.user = googleUserL;

          userRef.set(logincontroller.user!.toJson(), SetOptions(merge: true));
        } else {
          GoogleUser googleUserL = GoogleUser(
            id: currentUser.uid,
            displayName: currentUser.displayName!,
            email: currentUser.email!,
          );

          logincontroller.user = googleUserL;
          userRef.set(logincontroller.user!.toJson(), SetOptions(merge: true));
        }
      }, onError: (error) {
        setState(() {
          signInText = error.message.toString();
        });
      });
    }
  }


}