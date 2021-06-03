import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';

void main() {
  runApp(MyApps());
}

class MyApps extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    var res;
    Future<void> gett() async {
      res = await http.get("https://sdi-webserver.herokuapp.com/api/timetable",
          headers: {"semester": "6", "section": "C"});

      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);
        List<String> keylist;
        List<String> subjects = List<String>();
        int i, j;
        for (i = 0; i < 6; i++) {
          keylist = jsonData[i].keys.toList();
          for (j = 0; j < keylist.length; j++) {
            String slot = keylist[j];
            if (notin(jsonData[i][slot].toString())) {
              subjects.add(jsonData[i][slot].toString().substring(0, 5));
              print(jsonData[i][slot].toString().substring(0, 5));
            }
          }
        }
        //  print(outDB[0]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(subjects: subjects)));
      }
      ;
    }

    Size size = MediaQuery.of(context).size;
    Future<void> login() async {
      var res = await http.get(
          "https://sdi-webserver.herokuapp.com/api/students/login",
          headers: {"usn": "1BI18CS144", "password": "password"});
      print(res.statusCode);
      gett();
    }

    void forgotPassword() {
      print("Forgot password");
    }

    final TapGestureRecognizer _newRecognizer = TapGestureRecognizer()
      ..onTap = forgotPassword;
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.blue[900],
            Colors.blue[600],
            Colors.blue[400]
          ])),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(20),
                child: Text(
                  "Welcome BITan",
                  style: TextStyle(color: Colors.white, fontSize: 37),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: size.height * 0.9 - 103,
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 36,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Enter USN",
                              hintStyle: TextStyle(fontSize: 13),
                              labelText: "USN",
                              labelStyle:
                                  TextStyle(fontSize: 24, color: Colors.black),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            hintStyle: TextStyle(fontSize: 13),
                            labelText: "Password",
                            labelStyle:
                                TextStyle(fontSize: 24, color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                      Container(
                        child: Center(
                          child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 60),
                              onPressed: login,
                              color: Colors.blue[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Forgot Password?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              recognizer: _newRecognizer)
                        ]),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  bool notin(jsonData) {
    if()
    return true;
  }
}
