import 'package:flutter/material.dart';
import 'package:billing/components/text_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Preview extends StatefulWidget {
  const Preview({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final String productId;

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser!;

  dynamic _data = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: db
          .collection("product-${_user.uid}")
          .doc(widget.productId)
          .snapshots(),
      builder: (context, snapshot) {
        _data = snapshot.data?.data();

        if (_data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Preview")),
            body: const Center(
              child: Text("No Product Found"),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Preview")),
          body: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(_data["imageUrl"]),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(thickness: 2),
              const SizedBox(height: 15),
              TextRow(
                heading: "Product Name",
                text: _data["productName"],
              ),
              TextRow(
                heading: "Product Weight",
                text: "${_data["productWeight"]} gm",
              ),
              TextRow(
                heading: "Product Price",
                text: "₹ ${_data["productPrice"]}",
              ),
              const SizedBox(height: 15),
              const Divider(thickness: 2),
              const SizedBox(height: 15),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Continue"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("+ Add More"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
