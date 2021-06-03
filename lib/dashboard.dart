import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
            return Padding(
                padding: EdgeInsets.all(5.0),
                child: Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.3 + 25,
                          height: 90,
                        ),
                        Text(
                          subject,
                          style: TextStyle(fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}