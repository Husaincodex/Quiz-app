import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controller=TextEditingController();
  TextEditingController _controller2=TextEditingController();


  Future<int> getdata(String usn,String pw)async{
    var url="http://10.0.2.2/flutterdemo/index.php";
    http.Response response=await http.post(
        Uri.parse(url),
        headers: {"Accepts":"application/json"
        },
        body: {"username":usn,"password":pw,"login":"yes"
        }
    );
    if(response.statusCode==200){
      print(response.body);
      Map<String,dynamic> data=jsonDecode(response.body);
      //Toast.show(data["msg"], context);
      if(data["msg"]=="valid")
        return 1;
      else
        return 0;
    }
    else
    {
      Toast.show("connection failed", context);
    }
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 110.0,
                  child: Image.asset("assets/hi.jpg"),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(

                    decoration: InputDecoration(
                        hintText: "Username",
                        labelText: "Enter Username",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            )
                        )
                    ),
                    controller: _controller,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "Enter Password",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            )
                        )
                    ),
                    controller: _controller2,
                  ),

                ),
                ElevatedButton(onPressed: () {

                  getdata(_controller.text,_controller2.text).then((value) {
                    if(value==1)
                    {

                      Navigator.pushReplacementNamed(context, "/second",arguments: {"username":_controller.text});
                    }
                    else
                    {
                      Toast.show("invalid username and password", context);
                    }
                  },);


                }, child: Text("LOGIN")),
                GestureDetector(
                  child: RichText(text: TextSpan(
                      text: "Are You New User?",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(text:" Register Now",style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic)),
                      ]
                  ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/firstroute");
                  },
                ),
              ],
            )
        )
    );
  }
}
