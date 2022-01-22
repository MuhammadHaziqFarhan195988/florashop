import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class orderStatus extends StatefulWidget {
  @override
  _orderStatusState createState() => _orderStatusState();
}

class _orderStatusState extends State<orderStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.pink,Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0 , 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        centerTitle: true,
        title: Text("order statuses", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(icon: Icon(Icons.arrow_drop_down_circle),color: Colors.white, onPressed: (){
            Route route = MaterialPageRoute(builder: (c) => StoreHome());
            Navigator.pushReplacement(context, route);
          },),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: 100,
            height: 150,
            child: TimelineTile(
              endChild: Text('Order placed'),
              indicatorStyle: IndicatorStyle(
                color: Colors.pinkAccent,
                width: 50,
                iconStyle: IconStyle(iconData: Icons.article),
              ),
              isFirst: true,
            ),
          ),
          SizedBox(
            width: 100,
            height: 150,
            child: TimelineTile(
              endChild: Text('Order confirmed'),
              beforeLineStyle: LineStyle(color: Colors.red, thickness: 2),
              afterLineStyle: LineStyle(color: Colors.blue),
              indicatorStyle: IndicatorStyle(
                color: Colors.pinkAccent,
                width: 50,
                iconStyle: IconStyle(iconData: Icons.assignment_turned_in),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 150,
            child: TimelineTile(
              endChild: Text('Order processed'),
              beforeLineStyle: LineStyle(color: Colors.red, thickness: 2),
              afterLineStyle: LineStyle(color: Colors.blue),
              indicatorStyle: IndicatorStyle(
                color: Colors.pinkAccent,
                width: 50,
                iconStyle: IconStyle(iconData: Icons.access_time),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 150,
            child: TimelineTile(
              endChild: Text('Ready for pickup'),
              indicatorStyle: IndicatorStyle(
                color: Colors.pinkAccent,
                width: 50,
                iconStyle: IconStyle(iconData: Icons.verified),
              ),
              isLast: true,
            ),
          ),
        ],
      ),

    );
  }
}
