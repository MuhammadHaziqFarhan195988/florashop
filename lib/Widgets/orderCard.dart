import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florashop/Orders/OrderDetailsPage.dart';
import 'package:florashop/Models/item.dart';
import 'package:florashop/color_tone.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

int counter = 0;
class OrderCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String? orderID;
  
  OrderCard({Key? key,required this.itemCount,required this.data, this.orderID}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Route route;
        if(counter ==0){
          counter = counter +1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID!));
          Navigator.push(context, route);
        }
        
      },
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
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount*190.0,
        child: ListView.builder(itemBuilder: (c, index){ItemModel model = ItemModel.fromJson(data[index].data() as Map<String, dynamic>);
        return sourceOrderInfo(model, context);}, itemCount: itemCount,
        physics: NeverScrollableScrollPhysics(),),
      ),
    );
  }
}



Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color? background})
{
  width =  MediaQuery.of(context).size.width;

  return  Container(
    color: Colors.grey[100],
    height: 170.0,
    width: width,
    child: Row(
      children: [
        Image.network(model.thumbnailUrl!, width: 180.0,),
        SizedBox(width: 10.0,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.0,),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(model.title!, style: TextStyle(color: Colors.black, fontSize: 14.0),),

                  )
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(model.shortInfo!, style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          Text(
                            "Total Price: ",style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                          ),
                          Text(
                            "RM ", style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                          Text(
                            (model.price).toString(),style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),

            Flexible(
              child: Container(),
            ),
            //cart item remove
            Divider(
              height: 5.0,
              color: Colors.pink,
            ),
          ],
        ))
      ],
    ),

  );
}
