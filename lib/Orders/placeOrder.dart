import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:florashop/Config/config.dart';
import 'package:florashop/Counters/totalMoney.dart';
import 'package:florashop/Orders/payment.dart';
import 'package:florashop/Store/storehome.dart';
import 'package:florashop/Counters/cartitemcounter.dart';
import 'package:florashop/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
double getTotalamount=0;

class PaymentPage extends StatefulWidget {

  final String addressId;
  final double totalAmount;


  PaymentPage({Key key, this.addressId,this.totalAmount}): super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();

}


class _PaymentPageState extends State<PaymentPage> {


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.lightGreen[900],Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0 , 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(8.0),
              child: Image.asset("images/cash.png"),),
              SizedBox(height: 10.0,),
              FlatButton(color: Colors.blue ,onPressed: ()=>  takePayment(context,widget.totalAmount), padding: EdgeInsets.all(8.0),
              child: Text("Place order", style: TextStyle(color: Colors.white,fontSize: 30.0),),splashColor: Colors.deepOrange,)
            ],
          ),
        ),
      ),
    );
  }

  takePayment(mContext,double totalAmount){
    return showDialog(context: mContext, builder: (con){
      return SimpleDialog(
        title: Text("Choose Payment method", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
        children: [
          SimpleDialogOption(
            child: Text("Online transaction", style: TextStyle(color: Colors.green),),
            onPressed: (){
              Route route = MaterialPageRoute(builder: (c) => PaymentCredit(totalAmount: totalAmount,addressId: widget.addressId,));
              Navigator.pushReplacement(context, route);
            }
          ),
          SimpleDialogOption(
            child: Text("Cash on delivery", style: TextStyle(color: Colors.green),),
            onPressed: ()=>addOrderDetails(),
          ),
          SimpleDialogOption(
            child: Text("Cancel", style: TextStyle(color: Colors.green),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

        ],
      );
    });
  }

  addOrderDetails(){
    int number=Random().nextInt(999999);
    writeOrderDetailsForUser({
      EcommerceApp.addressID:widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      EcommerceApp.orderID: number.toString(),
    });

    writeOrderDetailsForAdmin({
      EcommerceApp.addressID:widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy" : EcommerceApp.sharedPreferences
          .getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      EcommerceApp.orderID: number.toString(),
    }).whenComplete(() => {
      emptyCartNow()
    });

  }

  emptyCartNow() async{
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

    Firestore.instance.collection("users").document( EcommerceApp.sharedPreferences
        .getString(EcommerceApp.userUID)).updateData({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Your orders have been placed successfully");

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.pushReplacement(context, route);


  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences
    .getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).document(EcommerceApp.sharedPreferences
        .getString(EcommerceApp.userUID) + data['orderTime']).setData(data);
  }

  Future writeOrderDetailsForAdmin (Map<String, dynamic> data) async {
    await EcommerceApp.firestore.collection(EcommerceApp.collectionOrders).document(EcommerceApp.sharedPreferences
        .getString(EcommerceApp.userUID) + data['orderTime']).setData(data);
  }
}
