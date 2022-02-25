import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:florashop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
// haziqf5@gmail.com haziq456
//delivery assumed to have standard delivery cost
//limit to peninsula malaysia due to special plant care akta kawalan penyakit
//also more expensive
//payment is only on cash on delivery method
//in future plans, i would include paywave method used by owner of the software
//need to include bank account for transfer money to seller
//require policy for refund (condition of plant) within 3 days of arrival
//picture of a delivered plant
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.lightGreen[900],Colors.lightGreenAccent],
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
          bottom: TabBar(
            tabs:[
              Tab(
                icon: Icon(Icons.lock, color: Colors.white,),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.white,),
                text: "Register",
              )
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.lightGreen[900],Colors.lightGreenAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,

              ),
          ),
          child: TabBarView(
            children: [
              Login(),
              Register(),
            ],
          ),
        ),
      ),
    );
  }
}
