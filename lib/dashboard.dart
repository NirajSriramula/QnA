import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stack_overflow/questions.dart';

class Dashboard extends StatelessWidget {
  List<String> subjects;
  Dashboard({this.subjects});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text("Subjects"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            String subject = subjects[index];
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 24),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Questions(subject: subject)));
                },
              ),
            );
          }),
    );
  }
}
