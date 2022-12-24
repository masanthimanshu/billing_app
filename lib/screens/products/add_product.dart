import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final String productId;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final _user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  bool _showImg = false;
  String _imageUrl = "";
  String _productName = "";
  String _productPrice = "";
  String _productWeight = "";

  dynamic _data = {};
  late File _imageFile;

  _uploadImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _showImg = true;
      });

      try {
        final imageRef = _storageRef.child("images/${image.name}");
        await imageRef.putFile(_imageFile);
        _imageUrl = await imageRef.getDownloadURL();
      } on FirebaseException catch (e) {
        debugPrint("Error => ${e.message}");
      }
    } else {
      debugPrint("Error occurred while uploading image");
    }
  }

  _uploadData() {
    final Map<String, dynamic> data = {
      "imageUrl": _imageUrl,
      "productName": _productName,
      "productId": widget.productId,
      "productPrice": _productPrice,
      "productWeight": _productWeight,
    };

    if (!_showImg) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Upload Image")),
      );
    } else {
      db
          .collection("product-${_user.uid}")
          .doc(widget.productId)
          .set(data)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: db
            .collection("product-${_user.uid}")
            .doc(widget.productId)
            .snapshots(),
        builder: (context, snapshot) {
          _data = snapshot.data?.data();

          if (_data != null) {
            return const Center(
              child: Text(
                "Product Already Exists",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  _showImg
                      ? Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(_imageFile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _uploadImage,
                            icon: const Icon(Icons.upload_outlined),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Text(
                    _showImg ? "Image Uploaded ✅" : "Upload Image",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.shopping_cart),
                        border: UnderlineInputBorder(),
                        labelText: "Product Name",
                        hintText: "Enter Product Name",
                      ),
                      onChanged: (text) => _productName = text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter product name";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.currency_rupee),
                        border: UnderlineInputBorder(),
                        labelText: "Product Price",
                        hintText: "Enter Product Price",
                      ),
                      onChanged: (text) => _productPrice = text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter product price";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.monitor_weight),
                        border: UnderlineInputBorder(),
                        labelText: "Product Weight (grams)",
                        hintText: "Enter Product Weight",
                      ),
                      onChanged: (text) => _productWeight = text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter product weight";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _uploadData();
                          }
                        },
                        child: const Text("Add Product"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
