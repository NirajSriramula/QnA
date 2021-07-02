import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _sharedPreferences;

void getSharedPreferenceInstance() async {
  _sharedPreferences = await SharedPreferences.getInstance();
}

Future<Void> fetchToken(String usn, String password) async {
  try {
    var res = await http.get(
        "https://sdi-webserver.herokuapp.com/students/login",
        headers: {"usn": usn, "password": password});
    if (res != null && res.body != null) {
      setToken(jsonDecode(res.body)['token']);
      setName(jsonDecode(res.body)['name']);
    } else {
      print('Facing error in fetching information');
    }
  } catch (e) {
    print(e);
  }
}

void setToken(String token) {
  _sharedPreferences.setString('token', token);
}

String getToken() {
  return _sharedPreferences.getString('token');
}

//save Name
void setName(String name) {
  _sharedPreferences.setString('name', name);
}

String getName() {
  _sharedPreferences.getString('name');
}
