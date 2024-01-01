import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florashop/Admin/adminShiftOrders.dart';
import 'package:florashop/Store/storehome.dart';
import 'package:florashop/Widgets/loadingWidget.dart';
import 'package:florashop/color_tone.dart';
//import 'package:florashop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:image/image.dart' as ImD;


class Sell extends StatefulWidget
{
  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> with AutomaticKeepAliveClientMixin<Sell>
{
  bool get wantKeepAlive => true;
  File? file;
  XFile? _imgpath;
  TextEditingController _descriptionEditingController = TextEditingController();
  TextEditingController _phoneNoEditingController = TextEditingController();
  TextEditingController _temperatureEditingController = TextEditingController();
  TextEditingController _waterConsumptionEditingController = TextEditingController();
  TextEditingController _mineralsEditingController = TextEditingController();
  TextEditingController _priceEditingController = TextEditingController();
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _shortEditingController = TextEditingController();
  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return file == null ? displaySellHomeScreen(): displayUploadFormScreen();
  }

  displaySellHomeScreen(){
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
        leading: IconButton(
          icon: Icon(Icons.assignment_turned_in_outlined, color: Colors.white,),
          onPressed: (){
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          TextButton(child: Text("Exit" , style: TextStyle(color: Colors.pink, fontSize: 16.0
              ,fontWeight: FontWeight.bold)


          ), onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => StoreHome());
            Navigator.pushReplacement(context, route);
          }, )
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody(){
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [ColorTone().firstTone,Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0 , 1.0],
            tileMode: TileMode.clamp,
          )
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two, color: Colors.white, size: 200.0,),
            Padding(padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                  foregroundColor: Colors.blue,
                ),
                
                child: Text("Add new Item", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                
                onPressed: ()=> takeImage(context),
              ),)
          ],
        ),
      ),
    );
  }

  takeImage(mContext){
    return showDialog(context: mContext, builder: (con){
      return SimpleDialog(
        title: Text("Item Image", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
        children: [
          SimpleDialogOption(
            child: Text("Capture with Camera", style: TextStyle(color: Colors.green),),
            onPressed: capturePhotoWithCamera,
          ),
          SimpleDialogOption(
            child: Text("Select from gallery", style: TextStyle(color: Colors.green),),
            onPressed: pickPhotoFromGallery,
          ),
          SimpleDialogOption(
            child: Text("Cancel", style: TextStyle(color: Colors.green),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

        ],
      );
    });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);

    _imgpath = await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);


    setState(() {
      file = File(_imgpath!.path);
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);

     _imgpath = await ImagePicker().pickImage(source: ImageSource.gallery,);


    setState(() {
      file = File(_imgpath!.path);
    });
  }

  displayUploadFormScreen(){
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
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: clearForm,),
        title: Text("New Product", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold,),),
        actions: [
          TextButton(onPressed: uploading ? null : ()=> uploadImageAndSaveItemInfo(), child: Text("Sell item" , style: TextStyle(color: Colors.pink, fontSize: 16.0, fontWeight: FontWeight.bold,),),)
        ],

      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file!), fit: BoxFit.cover)),
                ),

              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),

          ListTile(
              leading: Icon(Icons.perm_device_information, color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _shortEditingController,
                  decoration: InputDecoration(
                    hintText: "Short details",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information, color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _titleEditingController,
                  decoration: InputDecoration(
                    hintText: "title",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information, color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _descriptionEditingController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information, color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _priceEditingController,
                  decoration: InputDecoration(
                    hintText: "Price",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information, color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _phoneNoEditingController,
                  decoration: InputDecoration(
                    hintText: "phoneNo",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information, color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _temperatureEditingController,
                  decoration: InputDecoration(
                    hintText: "temperature",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information, color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _waterConsumptionEditingController,
                  decoration: InputDecoration(
                    hintText: "water intake per day",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
          Divider(color: Colors.pink,),
          ListTile(
              leading: Icon(Icons.perm_device_information, color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _mineralsEditingController,
                  decoration: InputDecoration(
                    hintText: "fertilizer nutrient",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
          Divider(color: Colors.pink,),
        ],
      ),
    );
  }

  clearForm(){
    setState(() {
      file = null;
      _descriptionEditingController.clear();
      _priceEditingController.clear();
      _shortEditingController.clear();
      _titleEditingController.clear();
      _phoneNoEditingController.clear();
      _temperatureEditingController.clear();
      _waterConsumptionEditingController.clear();
      _mineralsEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {

    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);

  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child("Items"); //ref
    UploadTask uploadTask = storageReference.child("product_$productID.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl){
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(productID).set({
      "shortInfo": _shortEditingController.text.trim(),
      "longDescription": _descriptionEditingController.text.trim(),
      "price": int.parse(_priceEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleEditingController.text.trim(),
      "phoneNo":int.parse(_phoneNoEditingController.text),
      "temperature": int.parse(_temperatureEditingController.text),
      "water": int.parse(_waterConsumptionEditingController.text),
      "minerals": _mineralsEditingController.text.trim(),

    });

    setState(() {
      file = null;
      uploading = false;
      productID = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionEditingController.clear();
      _titleEditingController.clear();
      _shortEditingController.clear();
      _priceEditingController.clear();
      _phoneNoEditingController.clear();
      _temperatureEditingController.clear();
      _waterConsumptionEditingController.clear();
      _mineralsEditingController.clear();
    });
  }
}
