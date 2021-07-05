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
  var question;
  String token;
  String usn;
  Answers({this.question, this.usn, this.token});

  @override
  _AnswersState createState() => _AnswersState(question, usn, token);
}

class _AnswersState extends State<Answers> {
  _AnswersState(var question, String usn, String token) {
    this.question = question;
    this.usn = usn;
    this.token = token;
  }

  @override
  void initState() {
    super.initState();
  }

  String subject;
  var question;
  String usn, token;
  List<String> answers;
  String new_answer;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (count < 1) {
      getAnswers();
      count++;
    }
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
                          "GP", //answers[index],
                          style: TextStyle(fontSize: 24),
                        ),
                        GestureDetector(
                          child: Row(
                            children: [
                              Text("credits"), //credits[index,]
                              Icon(Icons.arrow_upward, size: 26),
                            ],
                          ),
                          onTap: () {},
                        ),
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
        "https://sdi-webserver.herokuapp.com/api/stackOverFlow/addAnswer/" +
            question["_id"],
        headers: {"usn": usn, "token": token, "answer": new_answer});
    print(res.statusCode);
    count = 0;
    setState(() {});
  }

  Future<void> getupVote() async {
    //connect the upvote to backend
    setState(() {});
  }

  Future<void> getAnswers() async {
    print(question["answer"]);
    print(answers);
    setState(() {});
  }
}
