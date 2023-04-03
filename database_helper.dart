import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:shoppingcartprovider/cart_model.dart';

//this will help us to perform crud operations
class DBHelper{
  static Database? _db;

  Future<Database?> get dbase async{
    //agar db pehly se create huwa wa hu
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db;
  }
  initDatabase()async{
    //ye apke liyay path create kr rha ha mobile k andaar(database ko create krrha ha for localstorage memory)
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    //creating path
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
  _onCreate (Database db , int version) async {
    await db.execute('CREATE TABLE cart (id INTEGER PRIMARY KEY , productID VARCHAR UNIQUE , productName TEXT , initialPrice INTEGER , productPrice INTEGER , quantity INTEGER , unitTag TEXT , image TEXT)');
  }

  //to insert some value
  Future<Cart> insert(Cart cart)async{
    var dbClient = await dbase;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }
  //for cartscreen
//ye getCartList yaha pir jitni bi cart list hugi unko return karega  
  Future<List<Cart>> getCartList()async{
    var dbClient = await dbase;
    final List<Map<String , Object?>> queryresult = await dbClient!.query("cart");
    return queryresult.map((e) => Cart.fromMap(e)).toList();
  }
// to delete a product
Future<int> delete (int id)async{
  var dbClient = await dbase;
  return await dbClient!.delete(
    "cart",
    where: 'id = ?',
    whereArgs: [id]
    );
}
//to increase quantity
Future<int> updatequantity(Cart cart)async{
  var dbClient = await dbase;
  return await dbClient!.update(
    'cart',
    cart.toMap(),
    where: 'id = ?',
    whereArgs: [cart.id],
  );

}
}
 