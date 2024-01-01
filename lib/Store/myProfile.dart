
import 'package:florashop/Address/addAddress.dart';
import 'package:florashop/Authentication/authenication.dart';
import 'package:florashop/DialogBox/errorDialog.dart';
//import 'package:florashop/Orders/recent.dart';
import 'package:florashop/Store/profile.dart';
import 'package:flutter/material.dart';
import 'package:florashop/Profile/menu.dart';
import 'package:florashop/Profile/picture.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class Myprofile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Picture(),
          SizedBox(height: 20,),
         ProfileMenu(text: 'My Account',
           icon: 'assets/icons/User Icon.svg',
            press: () {},

         ),
          ProfileMenu(text: 'Order History',
            icon: 'assets/icons/Bill Icon.svg',
            press: () {
              
              showDialog(context: context, builder: (c){
        return ErrorAlertDialog(message: "Feature not available: please stay tuned!");
      });
              
            },

          ),
          ProfileMenu(text: 'Edit Account',
            icon: 'assets/icons/pencil.svg',
            press: () {
              Route route = MaterialPageRoute(builder: (c) => Profile());
              Navigator.pushReplacement(context, route);
            },
          ),
          ProfileMenu(text: 'Add address',
            icon: 'assets/icons/Location point.svg',
            press: () {
              Route route = MaterialPageRoute(builder: (c) => AddAddress());
              Navigator.pushReplacement(context, route);
            },
          ),
          ProfileMenu(text: 'Log out',
            icon: 'assets/icons/Log out.svg',
            press: () {
              Route route = MaterialPageRoute(builder: (c) => AuthenticScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ]
          ),
    );
  }
}




