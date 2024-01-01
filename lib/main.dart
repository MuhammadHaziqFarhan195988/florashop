import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florashop/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:florashop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  EcommerceApp.auth = FirebaseAuth.instance;
  
  EcommerceApp.firestore = FirebaseFirestore.instance;

  runApp(MyApp());
}
// [√] Flutter (Channel stable, 2.0.5, on Microsoft Windows [Version 10.0.19043.1526], locale en-US)

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (c)=> CartItemCounter()),
      ChangeNotifierProvider(create: (c)=> ItemQuantity()),
      ChangeNotifierProvider(create: (c)=> AddressChanger()),
      ChangeNotifierProvider(create: (c)=> TotalAmount()),
    ],
      child : MaterialApp(
        title: 'Flora shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
          home: SplashScreen()
    ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState(){
    super.initState();

    displaySplash();
  }

  displaySplash(){
    Timer(Duration(seconds: 5), () async {
    if(EcommerceApp.auth!.currentUser != null){
      Route route = MaterialPageRoute(builder: (_) => StoreHome());
      Navigator.pushReplacement(context, route);
    }
    else
      {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }

    });
  }
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [const Color.fromARGB(255, 51, 105, 30), Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0 , 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png"),
              SizedBox(height: 20.0),
              Text("Where you can get gardening at home",
              style: TextStyle(color: Colors.white),),

            ],
          ),
        ),
      ),
    );
  }
}
