import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  final upVotes;
  final downVotes;
  final numberQuesAsked;
  final numberQuesAnswered;

  const Profile(
      {key,
      this.upVotes,
      this.downVotes,
      this.numberQuesAsked,
      this.numberQuesAnswered})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> get() async {
    var res =
        await http.get("https://sdi-webserver.herokuapp.com/api/timetable");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Account")),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(5.0),
                child: Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 90,
                        ),
                        Text(
                          "Akhil", // get dynamic name
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    // onTap: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) =>
                    //               Questions(subject: subject)));
                    // },
                  ),
                ));
          }),
    );
  }
}
