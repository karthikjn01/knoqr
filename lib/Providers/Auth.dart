import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diinq/Components/PopUp.dart';
import 'package:diinq/Providers/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Auth extends ChangeNotifier {
  AuthState currentState = AuthState.lUnknown;
  User user;
  BuildContext context;

  static Future<dynamic> handleBGMessage(Map<String, dynamic> message) {
    print("backgroundMessage: $message");
  }

  Auth() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        currentState = AuthState.lOut;
        this.user = null;
      } else {
        print('User is signed in!');
        currentState = AuthState.lIn;
        this.user = user;

        FirebaseMessaging().getToken().then((value) {
          print("VALUE_VALUE: $value");
          FirebaseFirestore.instance
              .collection("People")
              .doc(user.uid)
              .set({"email": user.email, "uid": user.uid, "fcm": value});
        });

        FirebaseMessaging().onTokenRefresh.listen((event) {
          FirebaseFirestore.instance
              .collection("People")
              .doc(user.uid)
              .set({"email": user.email, "uid": user.uid, "fcm": event});
        });

        print(FirebaseMessaging().requestNotificationPermissions());

        FirebaseMessaging().configure(
          // onBackgroundMessage: handleBGMessage,
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message context: ${this.context}");
          },
          onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            // TODO optional
          },
          onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
            // TODO optional
          },
        );
      }
      notifyListeners();
    });
  }

  Future<String> registerUsingEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return "weak";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return "exists";
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> resetPassword(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> confirmReset(String code, String password) {
    return FirebaseAuth.instance
        .confirmPasswordReset(code: code, newPassword: password);
  }

  static Future<String> confirmResetCode(String code) {
    return FirebaseAuth.instance.verifyPasswordResetCode(code);
  }

  static Future<List<String>> getSignInMethods(String email) {
    return FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  }

  Future<String> signinUsingEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return "no user";
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return "wrong";
      }
    } catch (e) {
      print(e);
    }

    var _fcm = FirebaseMessaging();

    var token = await _fcm.getToken();
    await FirebaseFirestore.instance
        .collection("People")
        .doc(user.uid)
        .set({"email": user.email, "uid": user.uid, "fcm": token});
  }

  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    Provider.of<UserData>(context, listen: false).clear();
  }
}

enum AuthState {
  lIn,
  lOut,
  lUnknown,
}
