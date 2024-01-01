import 'dart:io';
import 'package:florashop/Config/config.dart';
//import 'package:florashop/DialogBox/errorDialog.dart';
import 'package:florashop/Store/storehome.dart';
//import 'package:florashop/Widgets/customAppBar.dart';
import 'package:florashop/Models/address.dart';
import 'package:florashop/Widgets/myDrawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:florashop/color_tone.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cEmail = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();
  late final String userImageUrl;

  File? _imageFile;
   XFile? _imagePath;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width;
        
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [ColorTone().firstTone, Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          centerTitle: true,
          title: Text("Edit Profile", style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(icon: Icon(Icons.arrow_drop_down_circle),
              color: Colors.white,
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => StoreHome());
                Navigator.pushReplacement(context, route);
              },),
          ],
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton.extended(onPressed: () {
          if (formKey.currentState!.validate()) {
            final model = AddressModel(name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cEmail.text.trim()).toJson();

            //add to Firestore
            EcommerceApp.firestore!.collection(EcommerceApp.collectionUser).
            doc(
                EcommerceApp.sharedPreferences!.getString(EcommerceApp.userUID)).
            collection(EcommerceApp.subCollectionAddress).doc(DateTime
                .now()
                .
            millisecondsSinceEpoch
                .toString()).set(model).then((value) {
              final snack = SnackBar(
                  content: Text("new address added successfully"));
              scaffoldKey.currentState!.showSnackBar(snack);
              FocusScope.of(context).requestFocus(FocusNode());
              formKey.currentState!.reset();
            });

            Route route = MaterialPageRoute(builder: (c) => StoreHome());
            Navigator.pushReplacement(context, route);


          }

             }, label: Text("Done"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.check),),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("please fill in the credentials",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold
                        , fontSize: 20.0),
                  ),
                ),
              ),
              InkWell(
                onTap: () => _selectAndPickImage(),
                child: CircleAvatar(
                  radius: _screenWidth * 0.15,
                  backgroundColor: Colors.white,
                  backgroundImage: null,
                  foregroundImage: _imageFile == null ? null : FileImage(
                      _imageFile!),
                  child: Icon(
                    Icons.add_photo_alternate, size: _screenWidth * 0.15,
                    color: Colors.grey,)
                      ,
                ),

              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "E-mail",
                      controller: cEmail,
                    ),
                    MyTextField(
                      hint: "Password",
                      controller: cState,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),

      ),

    );
  }

  Future<void> _selectAndPickImage() async {
    _imagePath = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
    _imageFile = File(_imagePath!.path);
  }

  uploadToStorage() async {
    /* showDialog(
        context : context
        ,builder: (c){
      return LoadingAlertDialog(
        message: "Please wait...",
      );
    }
    ); */

    String imageFileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    Reference storageReference = FirebaseStorage.instance.ref().child(
        imageFileName);

    UploadTask storageUploadTask = storageReference.putFile(_imageFile!);

    TaskSnapshot taskSnapshot = await storageUploadTask;

    await taskSnapshot.ref.getDownloadURL().then((url) {
      userImageUrl = url;
    });

    Future<void> uploadAndSaveImage() async {
      if (_imageFile == null) {
       /* showDialog(context: context, builder: (c) {
          return ErrorAlertDialog(message: "please select an image");
        }); */
      }
      else {
        uploadToStorage();
      }
    }
  }
}
class MyTextField extends StatelessWidget {

  final String hint;
  final TextEditingController controller;

  MyTextField({Key? key,required this.hint,required this.controller,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val!.isEmpty ? "Field cannot be empty" : null,
      ),
    );
  }
}
