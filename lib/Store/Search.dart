
import 'package:florashop/Models/item.dart';
import 'package:florashop/Store/storehome.dart';
import 'package:florashop/Widgets/myDrawer.dart';
import 'package:florashop/color_tone.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/customAppBar.dart';




class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}



class _SearchProductState extends State<SearchProduct> {

  Future<QuerySnapshot>? docList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(bottom: PreferredSize(child: searchWidget(), preferredSize: Size(56.0, 56.0),),),
        drawer: MyDrawer(),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap){
            return snap.hasData ? ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (context, index){
                ItemModel model = ItemModel.fromJson(snap.data!.docs[index].data() as Map<String, dynamic>);

                return sourceInfo(model, context);
              },
            ) : Text("No data available");
          },
        ),
      ),
    );
  }

  Widget searchWidget(){
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [ColorTone().firstTone,Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0 , 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 40.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.search, color: Colors.blueGrey,)
                ,),
              Flexible(child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value){
                    startSearching(value);
                  },
                  decoration: InputDecoration.collapsed(hintText: "search plants here using tags..."),
                ),
              ),)
            ],
          ),
        ),

    );
  }
 Future startSearching(String query) async {
docList = FirebaseFirestore.instance.collection("items").where("shortInfo", isGreaterThanOrEqualTo: query).get();
  }
}

