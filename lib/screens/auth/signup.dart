import 'package:billing_app/components/header.dart';
import 'package:billing_app/screens/auth/login.dart';
import 'package:billing_app/screens/auth/signup_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  String _user = "";
  String _pass = "";
  String _confirmPass = "";

  _handleSignUp() async {
    if (_pass == _confirmPass) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _user,
              password: _pass,
            )
            .then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupDetails(),
                  ),
                ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Weak Password")),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email Already Exists")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password Does Not Match")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Header(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_outlined),
                      border: UnderlineInputBorder(),
                      labelText: "Email",
                      hintText: "Enter Your Email",
                    ),
                    onChanged: (text) => _user = text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key),
                      border: UnderlineInputBorder(),
                      labelText: "Password",
                      hintText: "Enter Your Password",
                    ),
                    onChanged: (text) => _pass = text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key),
                      border: UnderlineInputBorder(),
                      labelText: "Confirm Password",
                      hintText: "Enter Your Password",
                    ),
                    onChanged: (text) => _confirmPass = text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _handleSignUp();
                        }
                      },
                      child: const Text("SIGN UP"),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Login(),
                      ),
                    );
                  },
                  child: const Text(
                    "LOGIN",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
