import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';


class result extends StatefulWidget {

  @override
  _resultState createState() => _resultState();
}

class _resultState extends State<result> {

  String _Name="";
  var _score="0";
  var _totalscore="0";


  Future getscore(String Sname)async {
    var url = "http://10.0.2.2/flutterdemo/index.php";
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {"Accepts": "application/json"},
      body: {"Student_name": Sname, "show": "yes"},
    );
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic>data = jsonDecode(response.body);
      setState(() {
        _score = data["score"];
        _totalscore=data["totalscore"];
      });
    }
    else {
Toast.show("connection failed", context);
    }
  }
  @override
  Widget build(BuildContext context) {
    final Map argument=ModalRoute.of(context)?.settings.arguments as Map;
    if(argument!=null){
      setState(() {
        if(_Name.isEmpty) {
          _Name = argument["Name"];
          getscore(_Name);
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Congratulations!"+" " "$_Name",style: TextStyle(color: Colors.green,fontSize: 20),),
            SizedBox(height: 10,width: 50),
            Image.asset("assets/smile.png",width: 400,),
            SizedBox(height: 10,width: 50),
                Text("Your Score is:",style: TextStyle(fontSize: 20)),
            SizedBox(height: 5,width: 50),
                CircleAvatar(child: Text(_score.toString()+"/"+_totalscore.toString(),style: TextStyle(fontSize: 20),),radius: 30,),
            SizedBox(height: 10,width: 50),
            ElevatedButton(
              onPressed: () {
              Navigator.pushReplacementNamed(context,"/detail" ,arguments: {"Name":_Name});
              },

              child: Text('View Detail Result'),
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shadowColor: Colors.black,
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(12),
                  // <-- Radius
                ),
              ),
            ),
            Divider(color: Colors.black),

        ElevatedButton(onPressed: () {
          Navigator.pushReplacementNamed(context, "/");
        }, child: Text("Start New Test"),style: ElevatedButton.styleFrom(backgroundColor: Colors.green),)
          ],
        ),
      ),
      
    );
  }
}
