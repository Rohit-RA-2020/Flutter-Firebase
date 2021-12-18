import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleWelcome extends StatelessWidget {
  const GoogleWelcome({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Welcome'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(user.photoUrl!),
          Text(user.displayName!),
          Text(user.email)
        ],
      )),
    );
  }
}
