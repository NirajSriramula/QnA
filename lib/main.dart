import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:stack_overflow/global.dart';
import 'dashboard.dart';
import 'package:direct_select/direct_select.dart';

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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String valueChoose;

  String usn, pass;
  @override
  Widget build(BuildContext context) {
    var res;

    Future<void> gett() async {
      String token = await getToken();
      res = await http.get("https://sdi-webserver.herokuapp.com/api/timetable",
          headers: {
            "semester": valueChoose,
            "section": "A",
            "token": token,
            "usn": usn
          });
      print(res.statusCode);
      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);
        List<String> keylist;
        List<String> subjects = List<String>();
        int i, j;
        //print(jsonData.toString());
        for (i = 0; i < jsonData.length; i++) {
          keylist = jsonData[i].keys.toList();
          //print(keylist.length);
          for (j = 0; j < keylist.length; j++) {
            String substr = jsonData[i][keylist[j]].toString();
            String subject = substr.split("/")[0];
            if (valueChoose == "6") {
              if (substr.contains("-")) {
                for (int k = 0; k < substr.split("/").length; k++) {
                  String lab = substr
                      .split("/")[k]
                      .split("-")[1]
                      .replaceAll(" ", "")
                      .replaceAll("	", "");
                  lab = lab.substring(0, lab.length - 3) +
                      " " +
                      lab.substring(lab.length - 3);
                  if (!subjects.contains(lab)) {
                    subjects.add(lab);
                  }
                }
              }
            }
            if (substr.contains("LAB") && !substr.contains("-")) {
              for (int k = 0; k < substr.split("/").length; k++) {
                String lab = substr.split("/")[k].substring(3);
                lab = lab.replaceAll(" ", "").replaceAll("	", "");
                lab = lab.substring(0, lab.length - 3) +
                    " " +
                    lab.substring(lab.length - 3);

                if (!subjects.contains(lab)) {
                  subjects.add(lab);
                }
              }
            } else if (!subjects.contains(subject) &&
                !substr.contains("-") &&
                !substr.contains("LAB")) {
              subjects.add(subject);
            }
          }
        }
        print(subjects);
        // previous method..
        /*for (i = 0; i < 6; i++) {
          keylist = jsonData[i].keys.toList();
          for (j = 0; j < keylist.length; j++) {
            String slot = keylist[j];
            String sub = jsonData[i][slot].toString();
            if (sub.contains("-") && !sub.contains("|")) {
              for (int k = 0; k < sub.split("/").length; k++) {
                String lab = sub.split("/")[k].split("-")[0];
                if (!subjects.contains(lab)) {
                  subjects.add(lab);
                }
              }
            }
            if (!subjects.contains(sub.split("/")[0]) &&
                !sub.contains("-") &&
                !sub.contains("|")) {
              subjects.add(sub.split("/")[0]);
              print(sub.split("/")[0]);
            }
          }
        }*/
        //  print(outDB[0]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(subjects: subjects)));
      }
      ;
    }

    var inputController1 = TextEditingController();
    var inputController2 = TextEditingController();
    List list = ["8", "6", "4"];
    Size size = MediaQuery.of(context).size;
    Future<void> login() async {
      fetchToken(usn, pass);
      List<String> subjects = [];
      subjects.add("SS & CD");
      subjects.add("CGV");
      subjects.add("WT");
      subjects.add("PE");
      subjects.add("OE");
      subjects.add("CGV LAB");
      subjects.add("SS & OS LAB");
      subjects.add("MAD LAB");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(subjects: subjects)));
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                  "Welcome BITan",
                  style: TextStyle(color: Colors.white, fontSize: 37),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: size.width - 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: inputController1,
                          maxLength: 10,
                          decoration: InputDecoration(
                              hintText: "Enter USN",
                              hintStyle: TextStyle(fontSize: 13),
                              labelStyle:
                                  TextStyle(fontSize: 24, color: Colors.black),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          obscureText: true,
                          controller: inputController2,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            hintStyle: TextStyle(fontSize: 13),
                            labelStyle:
                                TextStyle(fontSize: 24, color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          DropdownButton(
                              hint: Text("Semester"),
                              value: valueChoose,
                              onChanged: (newValue) {
                                setState(() {
                                  valueChoose = newValue;
                                });
                              },
                              items: list.map((valueItem) {
                                return DropdownMenuItem(
                                    value: valueItem, child: Text(valueItem));
                              }).toList()),
                        ],
                      ),
                      Container(
                        child: Center(
                          child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 60),
                              onPressed: () {
                                setState(() {
                                  usn = inputController1.text;
                                  pass = inputController2.text;
                                });

                                login();
                              },
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
                        height: 16,
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
                        height: 20,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
