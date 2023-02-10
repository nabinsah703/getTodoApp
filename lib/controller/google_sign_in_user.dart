import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInUser {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? user;

  GoogleSignInAccount? currentUser;

  static Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        Get.snackbar("Error", e.toString());
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
          Get.snackbar("Account exist", "Account Already Exists With Different Credential");
        } else if (e.code == 'invalid-credential') {
          Get.snackbar("Error", "Error Occurred While Accessing Credentials TryAgain");
        }
      } catch (e) {
        Get.snackbar("Error", "Error Occurred Using GoogleSignIn");
      }
    }
    return user;
  }

  static Future<void> signOut() async {
    // GoogleSignIn? googleSignIn = GoogleSignIn();
    // if (googleSignIn.currentUser != null) {
    //   await googleSignIn.disconnect();
    //   await FirebaseAuth.instance.signOut();
    // } else {
    //   await FirebaseAuth.instance.signOut();
    // }
    if (GoogleSignIn().currentUser != null) {
      await GoogleSignIn().signOut();
    }

    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      print(e.toString());
    }

    // await read(firebaseAuthProvider).signOut();
  }
}
