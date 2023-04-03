import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartprovider/productlist.dart';
import 'package:shoppingcartprovider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(
        builder: (BuildContext context){
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ProductList(), 
          );
        }
      ),
    );
  }
}