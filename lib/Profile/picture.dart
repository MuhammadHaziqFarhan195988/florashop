import 'package:florashop/Config/config.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Picture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 115,
          width: 115,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(EcommerceApp.sharedPreferences!.getString(EcommerceApp.userAvatarUrl)!,
                ),
              ),
              Positioned(
                  right: -12,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white),
                      ),
                        foregroundColor: Colors.green,
                      ),
                      
                      
                      
                      onPressed: (){

                      },
                      child: SvgPicture.asset('assets/icons/Camera Icon.svg',
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
