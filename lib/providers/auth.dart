import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/config.dart';
import 'package:shop/exceptions/firebase_exception.dart';

class Auth with ChangeNotifier {
  Future<void> signUp(String email, String password) async {
    final response = await http.post(
      BASE_URL_AUTH_SIGNUP,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseBody = json.decode(response.body);
    if (responseBody['error'] != null) {
      throw FirebaseException(responseBody['error']['message']);
    }

    return Future.value();
  }

  Future<void> signIn(String email, String password) async {
    final response = await http.post(
      BASE_URL_AUTH_SIGNIN,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseBody = json.decode(response.body);
    if (responseBody['error'] != null) {
      throw FirebaseException(responseBody['error']['message']);
    }

    return Future.value();
  }
}
