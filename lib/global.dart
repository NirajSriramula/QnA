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
  String token = jsonDecode(res.body)['token'].toString();
  setToken(token, usn);
}

Future<void> setToken(String token, String usno) async {
  _sharedPreferences = await SharedPreferences.getInstance();
  _sharedPreferences.setString("usn", usno);
  _sharedPreferences.setString('token', token);
}

Future<String> getToken() async {
  final _preferences = await SharedPreferences.getInstance();
  return _preferences.getString("token");
}
