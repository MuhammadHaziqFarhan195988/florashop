import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florashop/Config/config.dart';
import 'package:florashop/Models/address.dart';
import 'package:florashop/Orders//placeOrder.dart';
import 'package:florashop/Widgets/loadingWidget.dart';
import 'package:florashop/Widgets/wideButton.dart';
import 'package:florashop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget
{
  final double totalAmount;
  const Address({Key? key, required this.totalAmount}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}



class _AddressState extends State<Address>
{
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Select Address", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold, fontSize: 20.0),),
              ),
            ),
            Consumer<AddressChanger>(builder: (context,address,c){
              return Flexible(child: StreamBuilder<QuerySnapshot>(
                stream: EcommerceApp.firestore!.collection(EcommerceApp.collectionUser).
                  doc(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID)).
                  collection(EcommerceApp.subCollectionAddress).snapshots(),

                builder: (context, snapshot){
                  
                  return !snapshot.hasData ? Center(child: circularProgress(),)
                      : snapshot.data!.docs.length == 0 ? noAddressCard()
                      : ListView.builder(itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                        return AddressCard(
                          
                          currentIndex: address.count,
                          value: index,
                          addressId: snapshot.data!.docs[index].id,
                          totalAmount: widget.totalAmount,
                          model: AddressModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>),
                        );
                  },);
                },
              ));
            })
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: (){
          Route route = MaterialPageRoute(builder: (c) => AddAddress());
          Navigator.pushReplacement(context, route);
        }, label: Text("add new address",)
        ,backgroundColor: Colors.pink, icon: Icon(Icons.add_location),),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location, color: Colors.white),
            Text("no shipment address has been saved"),
            Text("please add your shipment address")
          ],
        ),
      ),

    );
  }
}

class AddressCard extends StatefulWidget {

  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;

  AddressCard({Key? key,required this.model,required this.currentIndex,required this.addressId,required this.totalAmount,
required      this.value}) : super(key: key);//need to study this


  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Provider.of<AddressChanger>(context, listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.pink,
                  onChanged: (val){
                    Provider.of<AddressChanger>(context,listen: false).displayResult(val!);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth*0.8,
                      child: Table(
                        children: [

                          TableRow(
                            children: [
                            KeyText(msg: "Phone Number",),
                              Text(widget.model.phoneNumber),

                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Flat Number",),
                              Text(widget.model.flatNumber),

                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "City",),
                              Text(widget.model.city),

                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "State",),
                              Text(widget.model.state),

                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Pin code",),
                              Text(widget.model.pincode),

                            ],
                          ),TableRow(
                            children: [
                              KeyText(msg: "Name",),
                              Text(widget.model.name),

                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count ? WideButton(
              message: "proceed",
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => PaymentPage(addressId: widget.addressId, totalAmount: widget.totalAmount,));

                Navigator.pushReplacement(context, route);
              },
            )
                : Container(),
          ],
        ),
      ),

    );
  }
}





class KeyText extends StatelessWidget {
final String msg;

KeyText({Key? key, required this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(msg, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),);
  }
}
