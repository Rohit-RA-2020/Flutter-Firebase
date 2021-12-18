import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_week4/screens/google_welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  final BuildContext context;
  GoogleSignInProvider({required this.context});

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GoogleWelcome(user: user)));
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
