import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florashop/Admin/adminLogin.dart';
import 'package:florashop/Widgets/customTextField.dart';
import 'package:florashop/DialogBox/errorDialog.dart';
import 'package:florashop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:florashop/Config/config.dart';
import 'package:florashop/color_tone.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width; 
   // _screenHeight = MediaQuery.of(context).size.height;

    


    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/login.png",height: 240.0,width: 240.0,),

            ),
            Padding(padding: EdgeInsets.all(8.0), child: Text("Login to flora shop",style: TextStyle(color: Colors.white),),),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  CustomTextField(
                    data: Icons.mail,
                    controller: _emailTextEditingController,
                    hintText: "Email",
                    isObsecure: false,
                  ),CustomTextField(
                    data: Icons.person,
                    controller: _passwordTextEditingController,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            ElevatedButton(onPressed: (){
              _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty
                  ? loginUser()
                  : showDialog(context: context,
                  builder: (c) {
                    return ErrorAlertDialog(message: "Please fill in the white box",);
                  });
            },
              style: ElevatedButton.styleFrom(
                foregroundColor: ColorTone().button1,
              ),//255, 233, 30, 99
              child: Text("Sign in", style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton.icon(onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder: (context) => AdminSignInPage())),
              icon: (Icon(Icons.nature_people, color: Colors.pink)),
              label: Text("Are you an Admin?", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),),
            ),

          ],
        ),
      ),
    );
  }


  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(context: context, builder: (c){
      return LoadingAlertDialog(message: "Please wait...",);
    });
    User? firebaseUser;
    await _auth.signInWithEmailAndPassword(email:_emailTextEditingController.text.trim(), password: _passwordTextEditingController.text.trim()).then((authUser){
      firebaseUser = authUser.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(context: context, builder: (c){
        return ErrorAlertDialog(message: error.message.toString(),);
      });
    });
    if(firebaseUser != null){
      {
        readData(firebaseUser!).then((s){
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }
    }
  }

  Future readData(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).get().then((dataSnapshot)
     async {
      await EcommerceApp.sharedPreferences!.setString("uid", dataSnapshot[EcommerceApp.userUID]);

      await EcommerceApp.sharedPreferences!.setString("email", dataSnapshot.data()![EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences!.setString("name", dataSnapshot.data()![EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences!.setString("url", dataSnapshot.data()![EcommerceApp.userAvatarUrl]);

dynamic cartListDynamic = dataSnapshot.data()![EcommerceApp.userCartList];
if (cartListDynamic is List<dynamic>) {
  List<String> cartList = cartListDynamic.map((item) => item.toString()).toList();
  // Now you have a valid List<String>
  print("cartList length");
      print(cartList.length.toString());
      await EcommerceApp.sharedPreferences!.setStringList(EcommerceApp.userCartList, cartList);
} 
      
    } );
  }
  
}
