import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/second.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
class second extends StatefulWidget {
  @override
  _secondState createState() => _secondState();
}

class _secondState extends State<second> {
  TextEditingController _controller=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MCQ APP"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              color: Colors.lime,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Enter your Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                controller: _controller,
              ),
            ),
          ),

          ElevatedButton(onPressed: () {
            Navigator.pushReplacementNamed(context, "/first",arguments: {"Name":_controller.text});
          },
          child: Text("START QUIZ"))

        ],
      ),
    );
  }
}
