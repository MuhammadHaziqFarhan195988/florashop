//import 'package:florashop/Orders/recent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class ProfileMenu extends StatelessWidget{
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }): super(key: key);

  final String text, icon;
  final VoidCallback press;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.all(20), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Color.fromARGB(255, 70, 202, 74)),
        
       
        
        onPressed: press ,


        child: Row(
          children: [
            SvgPicture.asset(icon, width: 22, color: Colors.white,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text,
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            ),
            Icon(Icons.arrow_forward_ios,color: Colors.white,),
          ],
        ),
      ),
    );
  }
}