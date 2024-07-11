import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
class detail extends StatefulWidget {
  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<detail> {
  int _count=0;
  var _Qno=[];
  var _Question=[];
  var _Correct_Answer=[];
  var _Given_Answer=[];
  String _Name="";
  var _Points=[];
  Future getdata(String Student_name)async{
    var url="http://10.0.2.2/flutterdemo/index.php";
    http.Response response=await http.post(
        Uri.parse(url),
        headers: {"Accepts":"application/json"},
        body: {"Student_name":Student_name,"detailscore":"yes"}
    );
    if(response.statusCode==200){
      print(response.body);
      Map<String,dynamic>data=jsonDecode(response.body);
      if(data.containsKey("msg")){
        Toast.show(data["msg"], context);
        setState(() {
          _Qno=[];
          _Question=[];
          _Correct_Answer=[];
          _Given_Answer=[];
          _Points=[];
        });
      }
      else{
        setState(() {
          _count=data["count"];
          _Qno=[];
          _Question=[];
          _Correct_Answer=[];
          _Given_Answer=[];
          _Points=[];
          for(int i=1;i<=_count;i++){
          _Qno.add(data["Qno"+i.toString()].toString());
          _Question.add(data["Question"+i.toString()]);
          _Correct_Answer.add(data["Correct_answer"+i.toString()]);
          _Given_Answer.add(data["Given_Answer"+i.toString()]);
          _Points.add(data["Points"+i.toString()].toString());
          }
        });
      }
    }
    else{
      Toast.show("connection failed", context);
      setState(() {
        _Qno=[];
        _Question=[];
        _Correct_Answer=[];
        _Given_Answer=[];
        _Points=[];
          });
    }
}
  @override
  Widget build(BuildContext context) {
    final Map argument=ModalRoute.of(context)?.settings.arguments as Map;
    if(argument!=null){
      setState(() {
        if(_Name.isEmpty) {
          _Name = argument["Name"];
          getdata(_Name);
        }
      });
    }
    return Scaffold(

      appBar: AppBar(
      elevation: 0,
        title: Text("Your Detail Score"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, "/result", arguments: {"Name": _Name});
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(itemCount: _count,itemBuilder: (context, index) {
       return Padding(
         padding: const EdgeInsets.all(4.0),
         child: Card(
           elevation: 10,
           color: (_Given_Answer[index]==_Correct_Answer[index])?Colors.green:Colors.red.shade400,
           child: ListTile(
              leading: Text(_Qno[index].toString()),
              title: Text(_Question[index].toString()),
              trailing: CircleAvatar(
                child: Text(_Points[index].toString()),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your given Answer is:"+" "+_Given_Answer[index].toString(),style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
                  Text("Correct Answer is:"+" "+_Correct_Answer[index].toString()+"\n",style: TextStyle(color: Colors.lime,fontWeight: FontWeight.bold),),
                ],
              ),

            ),
         ),

       );

      },)





      
      );
  }
}
