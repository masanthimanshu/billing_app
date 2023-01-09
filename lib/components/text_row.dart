import 'package:flutter/material.dart';

class TextRow extends StatelessWidget {
  const TextRow({
    Key? key,
    required this.heading,
    required this.text,
  }) : super(key: key);

  final String heading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
