import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florashop/Widgets/customTextField.dart';
import 'package:florashop/DialogBox/errorDialog.dart';
import 'package:florashop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:florashop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{

  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cpasswordTextEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userImageUrl = "";

  File? _imageFile;
  XFile? _imagePicker;
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0),
            InkWell(
              onTap: () => _selectAndPickImage(),
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile == null ? null : FileImage(_imageFile!),
                child: _imageFile == null
                    ? Icon(Icons.add_photo_alternate, size: _screenWidth * 0.15,color: Colors.grey,)
                    : null,
              ),

            ),
            SizedBox(height: 8.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: _nameTextEditingController,
                    hintText: "Name",
                    isObsecure: false,
                  ),
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
                  ),CustomTextField(
                    data: Icons.person,
                    controller: _cpasswordTextEditingController,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: (){
              uploadAndSaveImage();
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.blue,),
              child: Text("Sign Up", style: TextStyle(color: Colors.white),
            ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.blue,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _selectAndPickImage() async {
 _imagePicker =    await ImagePicker().pickImage(source: ImageSource.gallery);
 _imageFile = File(_imagePicker!.path);
  }

  Future<void> uploadAndSaveImage() async {
    if(_imageFile == null){
      showDialog(context: context, builder: (c){
        return ErrorAlertDialog(message: "please select an image");
      });
    }
    else {
      _passwordTextEditingController.text == _cpasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
          _passwordTextEditingController.text.isNotEmpty &&
    _cpasswordTextEditingController.text.isNotEmpty &&
          _nameTextEditingController.text.isNotEmpty

          ? uploadToStorage() : displayDialog("please write the info")

          :displayDialog("password do not match with ");
    }
  }

  displayDialog(String msg){
    showDialog(
      context : context
      ,builder: (c){
        return ErrorAlertDialog(
          message: msg,
        );
    }
    );
  }

  uploadToStorage() async {
    showDialog(
        context : context
        ,builder: (c){
      return LoadingAlertDialog(
        message: "Please wait...",
      );
    }
    );

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference = FirebaseStorage.instance.ref().child(imageFileName);

    UploadTask storageUploadTask = storageReference.putFile(_imageFile!);

    TaskSnapshot taskSnapshot = await storageUploadTask.whenComplete(() => null);

    await taskSnapshot.ref.getDownloadURL().then((url){
      userImageUrl = url;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
      User? firebaseUser;

       await _auth.createUserWithEmailAndPassword(
           email: _emailTextEditingController.text.trim(), password: _passwordTextEditingController.text.trim()).then((auth) {
         firebaseUser = auth.user!;
       }
       ).catchError((error) {
         Navigator.pop(context);
         showDialog(context: context, builder: (c){
           return ErrorAlertDialog(message: error.message.toString(),);
         });
       }

       );
      if(firebaseUser != null) {
        saveUserInfoToFireStore(firebaseUser!).then((value){
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }
      }

     Future saveUserInfoToFireStore(User fUser) async{
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });

    await EcommerceApp.sharedPreferences!.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences!.setString("email", fUser.email!);
    await EcommerceApp.sharedPreferences!.setString("name", _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences!.setString("url", userImageUrl);
    await EcommerceApp.sharedPreferences!.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}

