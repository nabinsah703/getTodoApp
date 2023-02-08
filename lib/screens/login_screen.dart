import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gettodoapp/model/google_user.dart';
import 'package:gettodoapp/screens/home_screen.dart';
import 'package:gettodoapp/services/google_sign_in_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseFirestore fbStore = FirebaseFirestore.instance;
  GoogleUser? _googleUser;
  String signInText = "You are not currently signed in.";

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _handleGoogleSignIn,
              label: const Text("Sign In With Google Account"),
              icon: const Icon(Icons.arrow_forward_ios_outlined),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      GoogleSignInUser.signInWithGoogle(context: context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => _googleUser != null ? const HomeScreen() : const LoginScreen()),
          (route) => false);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
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
}