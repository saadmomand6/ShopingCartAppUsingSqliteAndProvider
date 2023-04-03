// ignore_for_file: avoid_print

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartprovider/cart_model.dart';
import 'package:shoppingcartprovider/cartscreen.dart';
import 'package:shoppingcartprovider/database_helper.dart';
import 'package:shoppingcartprovider/provider.dart';
class ProductList extends StatefulWidget {
  const ProductList({super.key});
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  
  
  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;

  DBHelper? dbhelper = DBHelper();

  @override
  Widget build(BuildContext context) {
      //to get the cartprovider
    final cart = Provider.of<CartProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 255, 7),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 255, 7),
        title: const Text('My Fruit Shop',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        actions:  [
          InkWell(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=> const CartScreen()));
            },
            child: Center(
              child: (cart.counter == 0) ?  const Icon(Icons.shopping_bag_outlined , color: Colors.black,) : 
              
              
              Badge(
                
                badgeContent: Consumer<CartProvider>(
                  builder: ((context, value, child) {
                    return Visibility(
                      visible: value.getcounter().toString() == 0 ? false : true,
                      child: Text(
                        value.getcounter().toString(), 
                        style: const TextStyle(color: Colors.white),));
                  }),
                  ),
                position: BadgePosition.bottomEnd(),
                badgeAnimation: const BadgeAnimation.slide(
                  animationDuration: Duration(milliseconds: 300)
                ),
                badgeStyle: const BadgeStyle(badgeColor: Color.fromARGB(255, 254, 83, 83),),
                child: const Icon(Icons.shopping_bag_outlined , color: Colors.black,),
              ),
            ),
          ),
          const SizedBox(width: 20,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage(productImage[index].toString())),
                            const SizedBox(width: 10,),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productName[index].toString(),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                                    const SizedBox(height: 5,),
                                    Text("${productUnit[index].toString()} \$${productPrice[index].toString()}",
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                                    const SizedBox(height: 5,),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          dbhelper!.insert(
                                            Cart(
                                              id: index, 
                                              productID: index.toString(), 
                                              productName: productName[index].toString(), 
                                              initialPrice: productPrice[index], 
                                              productPrice: productPrice[index], 
                                              quantity: 1, 
                                              unitTag: productUnit[index].toString(), 
                                              image: productImage[index].toString())
                                          ).then((value) {
                                            cart.addtotalPrice(double.parse(productPrice[index].toString()));
                                            cart.addcounter();
                                          }).onError((error, stackTrace) {
                                            print(error.toString());
                                          });
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 251, 255, 7),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Center(
                                            child: Text('Add to Cart',style: TextStyle(color: Colors.black),),
                                          ),
                                        ),
                                      ),
                                    )
                              
                                  ],
                                ),
                              )
                        ],)
                      ],
                    ),
                  ),
                );
            }
            )
            )
      ],),
      );
  }
}
