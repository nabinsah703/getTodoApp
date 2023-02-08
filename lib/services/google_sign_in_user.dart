import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInUser {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? user;

  GoogleSignInAccount? currentUser;

  static getLoggedInUser() {
    try {
      user = auth.currentUser;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  static enableFirebasePersistance() {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      sslEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    if (kIsWeb) auth.setPersistence(Persistence.LOCAL);
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {}

      final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication!.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Account Already Exists With Different Credential")));
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Error Occurred While Accessing Credentials TryAgain")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error Occurred Using GoogleSignIn")));
      }
    }
    return user;
  }
}
