import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:billing/screens/bottom_navbar.dart';
import 'package:billing/screens/login_signup/login.dart';

class RootElement extends StatelessWidget {
  const RootElement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const BottomNavbar();
        } else {
          return const Login();
        }
      },
    );
  }
}
