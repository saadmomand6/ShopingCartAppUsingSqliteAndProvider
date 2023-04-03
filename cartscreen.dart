// ignore_for_file: avoid_print

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcartprovider/provider.dart';

import 'cart_model.dart';
import 'database_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbhelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 255, 7),
        title: const Text('Products in Cart',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        actions:  [
          Center(
            child: (cart.counter == 0) ?  const Icon(Icons.shopping_bag_outlined , color: Colors.black,) : 
            Badge(
              
              badgeContent: Consumer<CartProvider>(
                builder: ((context, value, child) {
                  return Text(value.getcounter().toString(), style: const TextStyle(color: Colors.white),);
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
          const SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: cart.getdata(),
              builder: (context , AsyncSnapshot<List<Cart>> snapshot){
                if (snapshot.hasData) {
                  if(snapshot.data!.isEmpty){
                    return Center(
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                      Image(image: AssetImage("assets/emptycart.png") ,height: 150, width: 150,),
                      SizedBox(height: 20,),
                      Text("Add Products to Your Cart" ,style: TextStyle(color: Colors.black , fontSize: 25)),
                  ],
                ),
                    );
                  }else{
                    return Expanded(
                    child: ListView.builder(
                itemCount: snapshot.data!.length,
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
                                image: NetworkImage(snapshot.data![index].image.toString())),
                              const SizedBox(width: 10,),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data![index].productName.toString(),
                                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                                          InkWell(
                                            onTap: (){
                                              dbhelper!.delete(snapshot.data![index].id!);
                                              cart.removecounter();
                                              cart.removetotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                            },
                                            child: const Icon(
                                              Icons.delete, color: Colors.red,)),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 5,),
                                      Text("${snapshot.data![index].unitTag.toString()} \$${snapshot.data![index].productPrice.toString()}",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                                      const SizedBox(height: 5,),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                           
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 251, 255, 7),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    int quantity = snapshot.data![index].quantity!;
                                                    int price = snapshot.data![index].initialPrice!;
                                                    quantity--;
                                                    int? newprice = price * quantity;
                                                    if (quantity > 0) {
                                                      dbhelper!.updatequantity(
                                                      Cart(
                                                        id: snapshot.data![index].id!, 
                                                        productID: snapshot.data![index].id!.toString(), 
                                                        productName: snapshot.data![index].productName!, 
                                                        initialPrice: snapshot.data![index].initialPrice!, 
                                                        productPrice: newprice, 
                                                        quantity: quantity, 
                                                        unitTag: snapshot.data![index].unitTag.toString(), 
                                                        image: snapshot.data![index].image.toString()
                                                        )
                                                    ).then((value) {
                                                      //to end the value
                                                      newprice = 0;
                                                      quantity = 0;
                                                      cart.removetotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                    }).onError((error, stackTrace) {
                                                      print(error.toString());
                                                    });
                                                    }
                                                    
                                                  },
                                                  child: const Icon(Icons.remove, color: Colors.blueGrey,),
                                                ),
                                                Text(snapshot.data![index].quantity.toString() ,style: const TextStyle(color: Colors.black),),
                                                InkWell(
                                                  onTap: (){
                                                    int quantity = snapshot.data![index].quantity!;
                                                    int price = snapshot.data![index].initialPrice!;
                                                    quantity++;
                                                    int? newprice = price * quantity;
                                                    dbhelper!.updatequantity(
                                                      Cart(
                                                        id: snapshot.data![index].id!, 
                                                        productID: snapshot.data![index].id!.toString(), 
                                                        productName: snapshot.data![index].productName!, 
                                                        initialPrice: snapshot.data![index].initialPrice!, 
                                                        productPrice: newprice, 
                                                        quantity: quantity, 
                                                        unitTag: snapshot.data![index].unitTag.toString(), 
                                                        image: snapshot.data![index].image.toString()
                                                        )
                                                    ).then((value) {
                                                      //to end the value
                                                      newprice = 0;
                                                      quantity = 0;
                                                      cart.addtotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                    }).onError((error, stackTrace) {
                                                      print(error.toString());
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.add , color: Colors.blueGrey,)),
                                              ],
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
              );
                  }
                  

                }
                return const Text('');
              }
              ),
              Consumer<CartProvider>(builder: (context, value, child) {
                return Visibility(
                  visible: value.gettotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black
                    ),
                    child: Column(
                      children: [
                        Reuseable(title: "Sub Total", value: r'$'+value.gettotalPrice().toStringAsFixed(2)),
                        Reuseable(title: "Discount 5%", value: r'$'+value.discount().toStringAsFixed(2)),
                        Reuseable(title: "Total Price", value: r'$'+value.discountedprice().toStringAsFixed(2)),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                );
              })
          ],
        ),
      ),
    );
  }
}
class Reuseable extends StatelessWidget {
  final String title , value;
  const Reuseable({super.key , required this.title , required this.value});  
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title , style: const TextStyle(fontSize: 15,color:Colors.yellow ),),
            Text(value.toString() , style: const TextStyle(fontSize: 15,color:Colors.yellow ),),
          ],
        ),
      ),
    );
  }
}