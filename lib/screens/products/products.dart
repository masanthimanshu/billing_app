import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billing_app/screens/products/add_product.dart';
import 'package:billing_app/screens/products/product_details.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore db = FirebaseFirestore.instance;

  List _data = [];

  _getData() async {
    final docRef = db.collection("product-${_user.uid}");
    QuerySnapshot querySnapshot = await docRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      _data = allData;
    });
  }

  _scanBarcode() async {
    String barcodeScanRes = "";

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ffffff', 'Cancel', true, ScanMode.BARCODE);
    } catch (err) {
      debugPrint("An Error Occurred");
    }

    if (!mounted) return;

    if (barcodeScanRes != "" && barcodeScanRes != "-1") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddProduct(
            productId: barcodeScanRes,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _data.isEmpty
              ? const Center(
                  child: Text(
                    "No Product Found",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : GridView.builder(
                  itemCount: _data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (e, index) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(_data[index]["imageUrl"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _data[index]["productName"],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text("Weight - ${_data[index]["productWeight"]} gm"),
                          Text("Price - ₹${_data[index]["productPrice"]}"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetails(
                                    productId: _data[index]["productId"],
                                  ),
                                ),
                              );
                            },
                            child: const Text("View Product"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _scanBarcode,
              child: const Text("Add Product"),
            ),
          ),
        ),
      ],
    );
  }
}
