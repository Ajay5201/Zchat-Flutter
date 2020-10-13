import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:zgram/pages/home.dart';


import 'pages/home.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';


void main()  {
//await Firestore.instance.settings().then((_){
  //print("no erroers in timestamp");
//}//,onError: (_){
  //print("there are errors in timestamp");
//});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zchat',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}