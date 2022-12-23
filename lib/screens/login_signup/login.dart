import 'package:flutter/material.dart';
import 'package:billing/components/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:billing/screens/login_signup/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String _user = "";
  String _pass = "";

  _handleLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _user,
        password: _pass,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User Not Found")),
        );
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong Password")),
        );
      }
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _handleLogin();
                        }
                      },
                      child: const Text("LOGIN"),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Signup(),
                      ),
                    );
                  },
                  child: const Text(
                    "SIGN UP",
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
