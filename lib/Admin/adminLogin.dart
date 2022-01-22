import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text("Flora shop",
          style: TextStyle(fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),

        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _adminIDTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;


    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.pink,Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0 , 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/admin.png",height: 240.0,width: 240.0,),

            ),
            Padding(padding: EdgeInsets.all(8.0), child: Text("Flora admin",style: TextStyle(color: Colors.white , fontSize: 28.0, fontWeight: FontWeight.bold), ),),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  CustomTextField(
                    data: Icons.person,
                    controller: _adminIDTextEditingController,
                    hintText: "ID",
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
            RaisedButton(onPressed: (){
              _adminIDTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty
                  ? loginAdmin()
                  : showDialog(context: context,
                  builder: (c) {
                    return ErrorAlertDialog(message: "Please fill in the white box",);
                  });
            },
              color: Colors.pink,
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
              height: 20.0,
            ),
            FlatButton.icon(onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder: (context) => AuthenticScreen())),
              icon: (Icon(Icons.nature_people, color: Colors.pink)),
              label: Text("Are you a user?", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 50.0,
            ),

          ],
        ),
      ),
    );
  }

 void loginAdmin(){
        Firestore.instance.collection("admins").getDocuments().then((snapshot){
        snapshot.documents.forEach((result){
          if(result.data["id"] != _adminIDTextEditingController.text.trim()){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("invalid ID")));
          }
          if(result.data["password"] != _passwordTextEditingController.text.trim()){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("invalid Password")));
          }
          else{
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Admin "+result.data["name"])));

          setState((){
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
            Route route = MaterialPageRoute(builder: (c) => UploadPage());
            Navigator.pushReplacement(context, route);

          }
        });
        });
  }
}
