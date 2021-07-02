import 'package:flutter/material.dart';

import 'answers.dart';
import 'package:http/http.dart' as http;

class Questions extends StatefulWidget {
  String subject;
  Questions({this.subject});

  @override
  _QuestionsState createState() => _QuestionsState(subject);
}

class _QuestionsState extends State<Questions> {
  String subject;
  _QuestionsState(String subject) {
    this.subject = subject;
  }
  String new_question;
  int count = 1;
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
                              builder: (context) =>
                                  Answers(question: new_question)));
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

  void postQuestion(String question) {}

  var res;

  Future<void> getQuestions() async {
    res = await http.get(
        "https://sdi-webserver.herokuapp.com/api/stackOverFlow/questions",
        headers: {"branch": "cse", "subject": subject, "year": "3"});
  }
}
