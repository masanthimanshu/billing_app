import 'package:flutter/material.dart';
import 'package:billing_app/screens/home/home.dart';
import 'package:billing_app/screens/scan/preview.dart';
import 'package:billing_app/screens/profile/profile.dart';
import 'package:billing_app/screens/products/products.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  _navigateUser(int index) {
    setState(() {
      _selectedIndex = index;
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
          builder: (_) => Preview(
            productId: barcodeScanRes,
          ),
        ),
      );
    }
  }

  final List _pages = [
    const Home(),
    const Products(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Billing App")),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _scanBarcode,
                icon: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateUser,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
