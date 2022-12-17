import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview")),
      body: Center(
        child: Text(productId),
      ),
    );
  }
}
