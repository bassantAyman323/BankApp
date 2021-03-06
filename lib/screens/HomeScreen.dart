
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0,left: 20.0),
      child: Column(
mainAxisAlignment: MainAxisAlignment.center,
       children: [

       // Expanded(child: Image(image:AssetImage('assets/7a365bca8c9383cfe6d0344978a68b47-removebg-preview.png'),fit: BoxFit.contain,)),
         Container(
            height: 300,
           width: double.infinity,
           child: Padding(
             padding: const EdgeInsets.all(15.0),

           ),
           decoration: BoxDecoration(
             image: DecorationImage(image: AssetImage('assets/7a365bca8c9383cfe6d0344978a68b47-removebg-preview.png'),fit: BoxFit.contain,

             ),

               borderRadius: BorderRadius.only(bottomRight:Radius.circular(60),topLeft: Radius.circular(60)),

               color:Colors.grey[200],

           ),
         ),
         SizedBox(height: 10,),
         Padding(
           padding: const EdgeInsets.all(10.0),
           child: Text(
             'Sparks Bank, is a new virtual bank. to enjoy the VR experience, while doing all your needs.',
             style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
         ),
       ],
      ),
    );
  }
}
