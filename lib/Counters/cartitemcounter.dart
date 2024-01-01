import 'package:flutter/foundation.dart';
import 'package:florashop/Config/config.dart';


class CartItemCounter extends ChangeNotifier{
  
  int _counter= EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList)!.length-1;
  int get count => _counter;


  

  CartItemCounter(){
    initializeCounter();
  }


  Future<void> initializeCounter() async {
    final sharedPreferences = EcommerceApp.sharedPreferences;
    if (sharedPreferences == null) {
      print("SharedPreferences is null.");
      return;
    }

    final userCartList = sharedPreferences.getStringList(EcommerceApp.userCartList);
    if (userCartList == null) {
      print("UserCartList is null.");
      _counter = 0;
      return;
    }

    print("UserCartList is not null");

    _counter = userCartList.length - 1;
    notifyListeners();
  }

 Future<void> displayResult() async {
   

    await Future.delayed(const Duration(milliseconds: 100), (){
      notifyListeners();
    });
  }
}