import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key, required this.auth, required this.user})
      : super(key: key);

  final UserCredential user;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Text('Logged in Sucessfully with email ${user.user!.email}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await auth.signOut();
            Navigator.pop(context);
          } on FirebaseAuth catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.exit_to_app),
      ),
    );
  }
}
