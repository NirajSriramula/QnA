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

class Questions extends StatefulWidget {
  String subject;
  String token;
  String univsn;
  Questions({this.subject, this.token, this.univsn});

  @override
  _QuestionsState createState() => _QuestionsState(subject, token, univsn);
}

class _QuestionsState extends State<Questions> {
  @override
  void initState() {
    super.initState();
  }

  String subject;
  String token;
  String univsn;
  Future<String> getToken() async {
    final _preferences = await SharedPreferences.getInstance();
    return _preferences.getString("token");
  }

  _QuestionsState(String subject, String token, String univsn) {
    this.subject = subject;
    this.token = token;
    this.univsn = univsn;
  }
  String new_question;
  int count = 0;
  var jsonData;
  List<String> questions = [];
  @override
  Widget build(BuildContext context) {
    if (count < 1) {
      getQuestions();
      count++;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions"),
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
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(5.0),
                child: Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                          height: 90,
                        ),
                        Text(
                          questions[index],
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Answers(
                                    question: jsonData["questions"][index],
                                    usn: univsn,
                                    token: token,
                                  )));
                    },
                  ),
                ));
          }),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Enter ur query'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              new_question = value;
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
            if (new_question != null) {
              postQuestion(new_question);
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

  Future<void> postQuestion(String question) async {
    res = await http.post(
        "https://sdi-webserver.herokuapp.com/api/stackOverFlow/addQuestion",
        headers: {
          "usn": univsn,
          "token": token,
          "question": question,
          "branch": "cse",
          "subject": subject,
          "year": "3",
        });
    print(res.statusCode);
    count = 0;
    questions.clear();
    setState(() {});
  }

  Future<void> getQuestions() async {
    print(token + "\n");
    print(univsn);
    res = await http.get(
        "https://sdi-webserver.herokuapp.com/api/stackOverFlow/questions",
        headers: {
          "branch": "cse",
          "subject": subject,
          "year": "3",
          "usn": univsn,
          "token": token
        });
    jsonData = json.decode(res.body);
    List<String> keylist;
    int i, j;
    print(jsonData["questions"].length);
    for (i = 0; i < jsonData["questions"].length; i++) {
      questions.add(jsonData["questions"][i]["question"]);
    }
    print(questions);
    setState(() {});
  }
}
