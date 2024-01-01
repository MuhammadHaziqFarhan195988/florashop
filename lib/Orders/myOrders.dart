import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florashop/Store/storehome.dart';
import 'package:florashop/Widgets/myDrawer.dart';
import 'package:florashop/color_tone.dart';
import 'package:flutter/material.dart';
import 'package:florashop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}



class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [ColorTone().firstTone,Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0 , 1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          centerTitle: true,
          title: Text("my orders", style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(icon: Icon(Icons.arrow_drop_down_circle),color: Colors.white, onPressed: (){
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },),
          ],
        ),
        drawer: MyDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore!.collection(EcommerceApp.collectionUser).
          doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders)
          .snapshots(),

          builder: (c, snapshot){
            return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c, index){
                return FutureBuilder<QuerySnapshot>(future: FirebaseFirestore.instance.collection("items").where("shortInfo", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)[EcommerceApp.productID])
                  .get()                                                                                                                                                     //skeptical probably Map instead of Map<String, dynamic>
                ,builder: (c, snap){
                  return snap.hasData ? OrderCard(
                    itemCount: snap.data!.docs.length,
                    data: snap.data!.docs,
                    orderID: snapshot.data!.docs[index].id,
                  ) : Center(child: circularProgress(),);
                  },);
              },
            ) : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
