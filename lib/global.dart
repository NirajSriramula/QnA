import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _sharedPreferences;

void getSharedPreferenceInstance() async {
  _sharedPreferences = await SharedPreferences.getInstance();
}

Future<Void> fetchToken(String usn, String password) async {
  var res = await http.get("https://sdi-webserver.herokuapp.com/students/login",
      headers: {"usn": usn, "password": password});
  setToken(jsonDecode(res.body)['token']);
}

void setToken(String token) {
  _sharedPreferences.setString('token', token);
}

String getToken() {
  return _sharedPreferences.getString('token');
}
