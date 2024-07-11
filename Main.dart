import 'dart:async';

import 'dart:io';



import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'package:flutter_app1/detail.dart';

import 'package:flutter_app1/firstroute.dart';

import 'package:flutter_app1/result.dart';

import 'package:flutter_app1/third.dart';

import 'package:flutter_app1/second.dart';

import 'package:toast/toast.dart';



void main() async{

  runApp(const MyApp());

}



class MyApp extends StatefulWidget {

  const MyApp({super.key});



  @override

  State<MyApp> createState() => _MyAppState();



}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.

  @override

  Widget build(BuildContext context) {

   return  MaterialApp(

     debugShowCheckedModeBanner: false,

      initialRoute: "/",

     routes: {

       "/":(context)=>second(),

       "/first":(context)=>firstroute(),

       "/result":(context) => result(),

       "/detail":(context)=>detail(),

     },

    );

  }

}





