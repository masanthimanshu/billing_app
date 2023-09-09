import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 60),
        Text(
          "Billing App",
          style: TextStyle(
            fontSize: 40,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text("Welcome back to the app you've missed"),
        SizedBox(height: 40),
      ],
    );
  }
}
