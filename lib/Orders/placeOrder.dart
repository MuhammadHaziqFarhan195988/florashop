import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:florashop/Config/config.dart';
//import 'package:florashop/Counters/totalMoney.dart';
import 'package:florashop/DialogBox/errorDialog.dart';
//import 'package:florashop/Orders/payment.dart';
//import 'package:florashop/Store/storehome.dart';
import 'package:florashop/Counters/cartitemcounter.dart';
import 'package:florashop/color_tone.dart';
import 'package:florashop/main.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
double getTotalamount=0;

class PaymentPage extends StatefulWidget {

  final String addressId;
  final double totalAmount;


  PaymentPage({Key? key, required this.addressId,required this.totalAmount}): super(key: key);
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
              colors: [ColorTone().firstTone,Colors.lightGreenAccent],
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
              TextButton(style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.blue) ,
                                            overlayColor: MaterialStateProperty.all(Color.fromARGB(255, 219, 117, 7)),
                                            
                                            ).merge(TextButton.styleFrom(
                                             padding: EdgeInsets.all(8.0),
                                            )),
                                            
                                            onPressed: ()=>  takePayment(context,widget.totalAmount), 
              
              child: Text("Place order", style: TextStyle(color: Colors.white,fontSize: 30.0),),)
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
              Route route = MaterialPageRoute(builder: (c) => ErrorAlertDialog(message: "Features not available, please stay tuned!"));
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
      "orderBy" : EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      EcommerceApp.orderID: number.toString(),
    });

    writeOrderDetailsForAdmin({
      EcommerceApp.addressID:widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy" : EcommerceApp.sharedPreferences!
          .getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      EcommerceApp.orderID: number.toString(),
    }).whenComplete(() => 
      emptyCartNow()
    );

  }

  emptyCartNow() async{
    await EcommerceApp.sharedPreferences!.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List<String>? tempList = EcommerceApp.sharedPreferences!.getStringList(EcommerceApp.userCartList);

    FirebaseFirestore.instance.collection("users").doc( EcommerceApp.sharedPreferences!
        .getString(EcommerceApp.userUID)).update({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences!.setStringList(EcommerceApp.userCartList, tempList!);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Your orders have been placed successfully");

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.pushReplacement(context, route);


  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore!.collection(EcommerceApp.collectionUser).doc(EcommerceApp.sharedPreferences!
    .getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).doc(EcommerceApp.sharedPreferences!
        .getString(EcommerceApp.userUID)! + data['orderTime']).set(data);
  }

  Future writeOrderDetailsForAdmin (Map<String, dynamic> data) async {
    await EcommerceApp.firestore!.collection(EcommerceApp.collectionOrders).doc(EcommerceApp.sharedPreferences!
        .getString(EcommerceApp.userUID)! + data['orderTime']).set(data);
  }
}
