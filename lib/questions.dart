import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_overflow/global.dart';
import 'package:stack_overflow/main.dart';

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
    getQuestions();
  }

  String subject;
  String token;
  String _usn;
  String univsn;
  Future<String> getPreff() async {
    final _preferences = await SharedPreferences.getInstance();
    final String usn = await _preferences.getString("usn");
    print(usn);
    setState(() => _usn = usn);
  }

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
  int count = 1;
  List<String> questions = [];
  @override
  Widget build(BuildContext context) {
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
          itemCount: count,
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
                          widget.subject,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Answers(
                                    question: new_question,
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
        headers: {"usn": univsn, "token": token, "question": question});
    print(res.statusCode);
    getQuestions();
  }

  Future<void> getQuestions() async {
    String usn = _usn;
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
    print(res.statusCode);
  }
}
