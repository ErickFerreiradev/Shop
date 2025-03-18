import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {

  Future<void> _authenticate(
    String email, String password, String urlFragment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:${urlFragment}?key=AIzaSyB5eOO56Zjq_DscYteLpohv0FmnXO5VT2U';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToke': true,
      }),
    );
      print(jsonDecode(response.body));
    }

  Future<void> signup(String email, String password) async {
    _authenticate(email, password, 'signup');
  }

  Future<void> login(String email, String password) async {
    _authenticate(email, password, 'signInWithPassword');
  }
}