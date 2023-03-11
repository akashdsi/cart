import 'package:cart/dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cart/cartmodel.dart';
class cartprovider with ChangeNotifier {
  int _counter = 0;
  double _tp = 0.0;
  int get counter => _counter;
  double get tp => _tp;
  DBHelper db = DBHelper();

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getData () async{
    _cart = db.getCartList();
    return _cart;
  }
  void _setpref() async {
    SharedPreferences prefe = await SharedPreferences.getInstance();
    prefe.setInt('cartitems', _counter);
    prefe.setDouble('totalprice', _tp);
    notifyListeners();
  }

  void _getpref() async {
    SharedPreferences prefe = await SharedPreferences.getInstance();
    _counter = prefe.getInt('cartitems') ?? 0;
    _tp = prefe.getDouble('totalprice') ?? 0;
    notifyListeners();
  }

  void addcounter() {
    _counter++;
    _setpref();
    notifyListeners();
  }

  void removecounter() {
    _counter--;
    _setpref();
    notifyListeners();
  }

  int getcounter() {
    _getpref();
    return _counter;
  }

  void addprice(double price) {
    _tp = _tp + price;
    _setpref();
    notifyListeners();
  }

  void removeprice(double price) {
    _tp = _tp - price;
    _setpref();
    notifyListeners();
  }

  double getprice() {
    _getpref();
    return _tp;
  }
}


