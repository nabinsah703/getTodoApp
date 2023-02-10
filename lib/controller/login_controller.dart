import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gettodoapp/model/google_user.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'google_sign_in_user.dart';

class Logincontroller extends GetxController {
  FirebaseFirestore fbStore = FirebaseFirestore.instance;
  bool isResult = false;
  Rx<GoogleUser?> _googleUser = GoogleUser().obs;
  RxString _signInText = "You are not currently signed in.".obs;

  String get signInText => _signInText.value;
  set signInText(String text) => _signInText.value = text;

  GoogleUser? get user => _googleUser.value;

  set user(GoogleUser? user) => _googleUser.value = user;

  void clear() {
    _googleUser.value = GoogleUser();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    GoogleSignInUser.auth.authStateChanges().listen((data) {
      if (data != null) {
        signInSignUp(data);
      } else {
        user = null;
      }
    });
    super.onInit();
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
        () => user != null ? const HomeScreen() : LoginScreen(),
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
          user = googleUserL;

          userRef.set(user!.toJson(), SetOptions(merge: true));
        } else {
          GoogleUser googleUserL = GoogleUser(
            id: currentUser.uid,
            displayName: currentUser.displayName!,
            email: currentUser.email!,
          );

          user = googleUserL;
          userRef.set(user!.toJson(), SetOptions(merge: true));
        }
      }, onError: (error) {
        signInText = error.message.toString();
      });
    }
  }
}
