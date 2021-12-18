import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_week4/services/auth.dart';
import 'package:firebase_week4/services/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;

  final _emailController = TextEditingController();
  final _passwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    label: Text('Email'),
                    hintText: 'Enter your email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  label: Text('Password'),
                  hintText: 'Enter your Password',
                ),
                obscureText: true,
              ),
              isLogin
                  ? ElevatedButton(
                      onPressed: () {
                        Authentication(
                          context: context,
                          email: _emailController.text,
                          password: _passwController.text,
                        ).logIn();
                      },
                      child: const Text('Log-In'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Authentication(
                          email: _emailController.text,
                          password: _passwController.text,
                          context: context,
                        ).signUp();
                      },
                      child: const Text('Sign-Up'),
                    ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: isLogin ? Text('Sign-up') : Text('Log-In')),
              ElevatedButton(
                  onPressed: () {
                    GoogleSignInProvider(
                      context: context,
                    ).googleLogin();
                  },
                  child: Text('SignIn With Google'))
            ],
          ),
        ),
      ),
    );
  }
}
