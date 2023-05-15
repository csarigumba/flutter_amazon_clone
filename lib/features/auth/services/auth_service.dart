import 'dart:convert';

import 'package:amazon_clone_tutorial/common/widgets/bottom_bar.dart';
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/models/user.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
      );

      String endpoint = "$url/api/signup";
      final res = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context: context, message: "Account created!");
          });
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      String endpoint = "$url/api/signin";
      final res = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString(
                'x-auth-token', json.decode(res.body)['token']);
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, (route) => false);
          });
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  Future<void> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      String endpoint = "$url/api/token-is-valid";
      var tokenRes = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        // Use the root API as it is the API for getting user data using JWT token
        final userRes = await http.get(
          Uri.parse("$url/api/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }
}
