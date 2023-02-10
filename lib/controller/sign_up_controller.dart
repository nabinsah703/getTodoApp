import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../screens/login_screen.dart';

class SignUpController extends GetxController {
  registration(String email, String password, String confirmPassword) async {
    if (password == confirmPassword) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        Get.snackbar(
          "success",
          "Registered Successfully. Please Login..",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => LoginScreen());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
            "weak password",
            "Weak Password",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
            "Used Email",
            "Account Already exists",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } else {
      Get.snackbar(
        "Not Match",
        "Password and Confirm Password doesn't match",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
