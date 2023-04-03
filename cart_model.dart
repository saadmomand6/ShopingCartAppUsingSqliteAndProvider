//model is created because jb hm "add to cart" pir click karingy tu localdatabase k andar cart ki value store karingy
//model se ham map karingy values ko sqlite database k andar for storing and for fetching
//yaad rahe k parameters k name same huny chaye
class Cart {
  late final int? id;
  final String? productID;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;
   
  //this is a constructor of cart class
  Cart({
    required this.id,
    required this.productID,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.image

  });
  //res = resources
  Cart.fromMap(Map<dynamic, dynamic>  res):
  id = res['id'],
  productID  = res['productID'],
  productName = res['productName'],
  initialPrice = res['initialPrice'],
  productPrice = res['productPrice'],
  quantity = res['quantity'],
  unitTag = res['unitTag'],
  image = res['image'];

  Map<String , Object?> toMap(){
    return {
      'id': id,
      'productID' : productID,
      'productName' : productName,
      'initialPrice' : initialPrice,
      'productPrice' : productPrice,
      'quantity' : quantity,
      'unitTag' : unitTag,
      'image' : image,

    };
  }
 

}