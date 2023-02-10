import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gettodoapp/model/google_user.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'google_sign_in_user.dart';

class Logincontroller extends GetxController {
  bool isResult = false;
  Rx<GoogleUser?> _googleUser = GoogleUser().obs;

  GoogleUser? get user => _googleUser.value;

  set user(GoogleUser? user) => _googleUser.value = user;

  void clear() {
    _googleUser.value = GoogleUser();
  }

  void login(String email, String password) async {
    try {
      if (await userSign(email, password)) {
        Get.offAll(() => const HomeScreen());
        Get.snackbar(
          "Login",
          "Logging successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Email Address or Password is wrong",
          snackPosition: SnackPosition.BOTTOM,
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
        Get.snackbar(
          "Not found",
          "No user found for that email.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    return isResult;
  }

  Future<void> handleGoogleSignIn() async {
    try {
      await GoogleSignInUser.signInWithGoogle();
      Get.offAll(
        () => user != null ? const HomeScreen() : const LoginScreen(),
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        error.toString(),
      );
    }
  }
}
