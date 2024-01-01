import 'package:florashop/Widgets/myDrawer.dart';
import 'package:florashop/color_tone.dart';
import 'package:flutter/material.dart';

//import 'package:florashop/Orders/recent.dart';
import 'package:florashop/Store/myProfile.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text("Flora shop",
          style: TextStyle(fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),

        ),
        centerTitle: true,
      ),
        drawer: MyDrawer(),
      body: Myprofile(),

    );
  }
}