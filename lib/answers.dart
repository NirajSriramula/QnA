import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_overflow/global.dart';
import 'package:stack_overflow/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_overflow/global.dart';
import 'package:stack_overflow/main.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:stack_overflow/global.dart';
import 'dashboard.dart';
import 'package:direct_select/direct_select.dart';

import 'answers.dart';

import 'package:http/http.dart' as http;

class Answers extends StatefulWidget {
  String question;
  String token;
  String usn;
  Answers({this.question, this.usn, this.token});

  @override
  _AnswersState createState() => _AnswersState(question, usn, token);
}

class _AnswersState extends State<Answers> {
  _AnswersState(String question, String usn, String token) {
    this.question = question;
    this.usn = usn;
    this.token = token;
  }

  @override
  void initState() {
    super.initState();
    getAnswers();
  }

  String subject;
  String question, usn, token;
  List<String> answers;
  String new_answer;
  @override
  Widget build(BuildContext context) {
    int count = 2;
    return Scaffold(
      appBar: AppBar(
        title: Text("Answers"),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            },
          )
        ],
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: count, //answers.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(5.0),
                child: Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "wdwas", //answers[index],
                          style: TextStyle(fontSize: 24),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("credits"), //credits[index,]
                                Icon(Icons.arrow_upward, size: 26),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Answers(question: new_answer)));
                    },
                  ),
                ));
          }),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Enter ur answer'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: "Enter your answer"),
            onChanged: (value) {
              new_answer = value;
            },
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('Close'),
        ),
        new FlatButton(
          onPressed: () {
            if (new_answer != null) {
              postAnswer(new_answer);
            }

            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('Submit'),
        ),
      ],
    );
  }

  var res;
  Future<void> postAnswer(String new_answer) async {
    res = await http.post(
        "https://sdi-webserver.herokuapp.com/api/stackOverFlow/addAnswer/:questionId",
        headers: {"usn": usn, "token": token, "answer": new_answer});
    print(res.statusCode);
  }

  Future<void> getAnswers() async {
    res = await http.get(
        "https://sdi-webserver.herokuapp.com/stackOverFlow/getQuestion/:questionId",
        headers: {"usn": usn, "token": token, "question": question});
    print(res.statusCode);
    var jsonData = json.decode(res.body);
    int i, j;
    print(jsonData["questions"].length);
    for (i = 0; i < jsonData["questions"].length; i++) {
      answers.add(jsonData["questions"][i]["question"]);
    }
    print(answers);
    setState(() {});
  }
}
