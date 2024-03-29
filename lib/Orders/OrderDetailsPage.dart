import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florashop/Address/address.dart';
import 'package:florashop/Config/config.dart';
import 'package:florashop/DialogBox/errorDialog.dart';
import 'package:florashop/Store/profile.dart';
import 'package:florashop/Store/storehome.dart';
import 'package:florashop/Widgets/loadingWidget.dart';
import 'package:florashop/Widgets/orderCard.dart';
import 'package:florashop/Models/address.dart';
import 'package:florashop/color_tone.dart';
import 'package:florashop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
//import 'package:florashop/Store/delivery_timeline.dart';

String getOrderId="";

class OrderDetails extends StatelessWidget {

  final String orderID;

  OrderDetails({Key? key,required this.orderID,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future:     EcommerceApp.firestore!.collection(EcommerceApp.collectionUser).doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders).doc(orderID).get(),
                builder: (c, snapshot){
                  late Map dataMap;
                  if(snapshot.hasData){
                    dataMap= snapshot.data!.data() as Map;
                  }
                  return snapshot.hasData ? Container(
                    child: Column(
                      children: [
                        StatusBanner(status: dataMap[EcommerceApp.isSuccess],),
                        SizedBox(height: 10.0,),
                        Padding(padding: EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("RM "+ dataMap[EcommerceApp.totalAmount].toString(),
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),),
                        ),
                        ),
                        Padding(padding: EdgeInsets.all(4.0),
                             child: Text("Order ID: "+ getOrderId),
                        ),
                        Padding(padding: EdgeInsets.all(4.0),
                          child: Text("Ordered at: " + DateFormat("dd MMMM, yyyy - hh:mm aa").
                          format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),),

                        ),
                        Divider(height: 2.0,),
                        FutureBuilder<QuerySnapshot>(
                          future: EcommerceApp.firestore!.collection("items").where("shortInfo",
                          whereIn: dataMap[EcommerceApp.productID])
                          .get(),
                          builder: (c, dataSnapshot){
                            return dataSnapshot.hasData ? OrderCard(
                              itemCount: dataSnapshot.data!.docs.length,
                              data: dataSnapshot.data!.docs,
                            ) : Center(child:
                              circularProgress(),);
                          },
                        ),
                        Divider(height: 2.0,),
                        FutureBuilder<DocumentSnapshot>(future: EcommerceApp.firestore!.collection(EcommerceApp.collectionUser).doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
                            .collection(EcommerceApp.subCollectionAddress).doc(dataMap[EcommerceApp.addressID]).get(),
                          builder: (c, snap){
                          return snap.hasData ? ShippingDetails(model: AddressModel.fromJson(snap.data!.data() as Map<String, dynamic>),orderID: orderID,) : Center(
                            child: circularProgress(),
                          );
                          },
                        ),
                      ],
                    ),
                  )
                      : Center(child: circularProgress(),);
                },
          ),
        ),
      ),
    );
  }
}



class StatusBanner extends StatelessWidget {

  final bool status;

  StatusBanner({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "Unsuccessful";

    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [ColorTone().firstTone,Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0 , 1.0],
            tileMode: TileMode.clamp,
          )
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            "Order Placed " + msg,
            style: TextStyle(color: Colors.white),

          ),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          )

        ],
      ),
    );
  }
}



class ShippingDetails extends StatelessWidget {

  final AddressModel model;
  final String orderID;
  ShippingDetails({Key? key, required this.model, required this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10.0,),
          child: Text("Shipment Details:", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [

              TableRow(
                children: [
                  KeyText(msg: "Phone Number",),
                  Text(model.phoneNumber),

                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Flat Number",),
                  Text(model.flatNumber),

                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "City",),
                  Text(model.city),

                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "State",),
                  Text(model.state),

                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: "Pin code",),
                  Text(model.pincode),

                ],
              ),TableRow(
                children: [
                  KeyText(msg: "Name",),
                  Text(model.name),

                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(10.0),
          child: new Column (
          children: [
            new Center(
              child: InkWell(
                onTap: (){
                  confirmedUserOrderReceived(context, getOrderId);
                },
                child: Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [Colors.green,Colors.green],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0 , 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width - 40.0,
                  height: 50.0,
                  child: Center(
                    child: Text("Confirmed", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                ),),
              ),

            ),
            Divider(
              height: 5.0,
              color: Colors.white,
            ),
            new Center(
              child: InkWell(
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c) => ErrorAlertDialog(message: "Not available: file not found"));
                  Navigator.pushReplacement(context, route);
                },
                child: Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [Colors.blue,Colors.blue],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0 , 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width - 40.0,
                  height: 50.0,
                  child: Center(
                    child: Text("Your package progress", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                  ),),
              ),


            ),
            Divider(
              height: 5.0,
              color: Colors.white,
            ),
            new Center(
              child: InkWell(
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c) => Profile());
                  Navigator.pushReplacement(context, route);
                },
                child: Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [Colors.red,Colors.red],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0 , 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width - 40.0,
                  height: 50.0,
                  child: Center(
                    child: Text("Refund", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                  ),),
              ),

            ),
          ],
        ),
        )],
          );

  }

  confirmedUserOrderReceived(BuildContext context,String mOrderId){
    EcommerceApp.firestore!.collection(EcommerceApp.collectionUser).doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders).doc(mOrderId).delete();

    getOrderId ="";

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order has been received");
  }
}



