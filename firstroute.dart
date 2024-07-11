import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
class firstroute extends StatefulWidget {

  @override
  _firstrouteState createState() => _firstrouteState();
}


class _firstrouteState extends State<firstroute> {

  String _Answer="";
  var _Qno=[];
  var _Question=[];
  var _Answer1=[];
  var _Answer2=[];
  var _Answer3=[];
  var _Answer4=[];
  var _Correct_Answer=[];
  var _Points=[];
  int _count=0;
  int _current_index=0;
  int _value=60;
  String _Name="";
  late Timer tm;
  void starttimer()
  {
    const sec=const Duration(seconds: 1);
    tm=new Timer.periodic(sec, (timer) {
      setState(() {
        if(_value>0)
          _value--;
        else
          stoptimer();
      });
    },);

  }
  void stoptimer()
  {
    tm.cancel();
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Time Up",style: TextStyle(color: Colors.red),),
        actions: [
          ElevatedButton(onPressed: () {
            _Answer="NA";
            insertdata(_Name, _Qno[_current_index].toString(),
                _Correct_Answer[_current_index], _Answer,
                _Points[_current_index].toString()).then((value) {
              setState(() {
                if (_current_index < _count - 1) {
                  _current_index++;
                  _Answer = "";
                  _value=60;
                  starttimer();
                }
                else {
                  Navigator.pushReplacementNamed(
                      context, "/result", arguments: {"Name": _Name});
                }
              });
            },);
            Navigator.of(context).pop();
          }, child: Text("Ok"))
        ],
      );
    },);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    starttimer();
  }
  Future getdata()async{
    var url="http://10.0.2.2/flutterdemo/index.php";
    http.Response response=await http.post(
      Uri.parse(url),
      headers: {"Accepts":"application/json"},
      body: {"fetchcart":"yes"}
    );
    if(response.statusCode==200){
      print(response.body);
      Map<String,dynamic>data=jsonDecode(response.body);
      if(data.containsKey("msg")){
        Toast.show(data["msg"], context);
        setState(() {
          _Qno=[];
          _Question=[];
          _Answer1=[];
          _Answer2=[];
          _Answer3=[];
          _Answer4=[];
          _Correct_Answer=[];
          _Points=[];
        });
      }
      else{
        setState(() {
          _count=data["count"];
          _Question=[];
          _Answer1=[];
          _Answer2=[];
          _Answer3=[];
          _Answer4=[];
          _Correct_Answer=[];
          _Points=[];
          for(int i=1;i<=_count;i++){
            _Qno.add(data["Qno"+i.toString()].toString());
            _Question.add(data["Question"+i.toString()]);
            _Answer1.add(data["Answer1"+i.toString()]);
            _Answer2.add(data["Answer2"+i.toString()]);
            _Answer3.add(data["Answer3"+i.toString()]);
            _Answer4.add(data["Answer4"+i.toString()]);
            _Correct_Answer.add(data["Correct_Answer"+i.toString()]);
            _Points.add(data["Points"+i.toString()]);
          }
        });
      }
    }
    else{
      Toast.show("connection failed", context);
      setState(() {
        _Qno=[];
        _Question=[];
        _Answer1=[];
        _Answer2=[];
        _Answer3=[];
        _Answer4=[];
        _Correct_Answer=[];
        _Points=[];
      });
    }
  }
Future<int> insertdata(String sname,String qno,String canswer,String givenans,String point)async{
  var url="http://10.0.2.2/flutterdemo/index.php";
  http.Response response=await http.post(
      Uri.parse(url),
      headers: {"Accepts":"application/json"},
      body: {"sname":sname,"qno":qno,"canswer":canswer,"givenans":givenans,"point":point,"add":"yes"}
  );
  if(response.statusCode==200){
    print(response.body);
    Map<String,dynamic>data=jsonDecode(response.body);
   // Toast.show(data["msg"], context);
  }
  else{
    Toast.show("Connection failed",context);
  }
  return 1;
}



  @override
  Widget build(BuildContext context) {
    final Map argument=ModalRoute.of(context)?.settings.arguments as Map;
    if(argument!=null){
      setState(() {
        _Name=argument["Name"];
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Test page"),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child:_count>0? Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    boxShadow: [BoxShadow(
                      color: Colors.yellow,
                      blurRadius: 5.0,

                    ),]
                ),
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text(_Qno[_current_index].toString()+"/"+_count.toString(),style: TextStyle(fontSize: 20),)),
                  CircleAvatar(radius: 20,child: Text(_value.toString())
                  ),
                ],
              ),
              height: 40,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text(_Question[_current_index],style: TextStyle(color: Colors.cyan,fontStyle: FontStyle.italic))),
                SizedBox(width:30,child: Text(_Points[_current_index].toString()+" Pts.",style: TextStyle(color: Colors.red,fontSize: 12)))
              ],
            ),
            ListTile(
              title: Text(_Answer1[_current_index]),
              leading: Radio(
                value: "A",
                groupValue: _Answer,
                onChanged: (value) {
                  setState(() {
                    _Answer=value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(_Answer2[_current_index]),
              leading: Radio(
                value: "B",
                groupValue: _Answer,
                onChanged: (value) {
                  setState(() {
                    _Answer=value!;
                  });
                },
              ),
            ),ListTile(
              title: Text(_Answer3[_current_index]),
              leading: Radio(
                value: "C",
                groupValue: _Answer,
                onChanged: (value) {
                  setState(() {
                    _Answer=value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(_Answer4[_current_index]),
              leading: Radio(
                value: "D",
                groupValue: _Answer,
                onChanged: (value) {
                  setState(() {
                    _Answer=value!;
                  });
                },
              ),
            ),
              ElevatedButton(onPressed: () {
      if(!_Answer.isEmpty) {
        insertdata(_Name, _Qno[_current_index].toString(),
            _Correct_Answer[_current_index], _Answer,
            _Points[_current_index].toString()).then((value) {
          setState(() {
            if (_current_index < _count - 1) {
              _current_index++;
              _Answer = "";
              _value=60;
            }
            else {
              Navigator.pushReplacementNamed(
                  context, "/result", arguments: {"Name": _Name});
            }
          });
        },);
      }
      else
        {
          Toast.show("plz select any one option", context);
        }
              }, child: Text("Submit"))

          ],

        ):Container(),
      ),
    );
  }
}

