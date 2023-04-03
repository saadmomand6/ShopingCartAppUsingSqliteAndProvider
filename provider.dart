import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcartprovider/database_helper.dart';
import 'cart_model.dart';

class CartProvider  with ChangeNotifier{
  // here we will manage total price and itemcount ko manage krna ha
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  // ta ke agar hum project ko end krke wapis aai tab bi hamary products add hu cart me (that's why used sharedpresferences)
  void _setPrefItems()async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    pref.setInt('cart_item', _counter);
    pref.setDouble('total_price', _totalPrice);
    notifyListeners();
  }
  void _getPrefItems()async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    _counter = pref.getInt('cart_item') ?? 0;
    _totalPrice = pref.getDouble('total_price') ?? 0.0;  
    notifyListeners();
  }
  void addtotalPrice(double productPrice){
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }
  void removetotalPrice(double productPrice){
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }
  double gettotalPrice(){
    _getPrefItems();
    return _totalPrice;
  }
  void addcounter (){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }
  void removecounter (){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }
  int getcounter (){
    _getPrefItems();
    return _counter;
  }
  //for cartscreen
  DBHelper db = DBHelper();

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;
  //ye hamesha database se record fetch krke laigi
  Future<List<Cart>> getdata() async {
    _cart = db.getCartList();
    return _cart;
  }

  double discount(){
    var discount = _totalPrice * 5 / 100;
    return discount;
  }
  double discountedprice(){
    var discountedprice = _totalPrice - _totalPrice*5/100;
    return discountedprice;

  }

}