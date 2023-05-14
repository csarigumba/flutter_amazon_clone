import 'dart:convert';

import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandler(
    {required http.Response response,
    required BuildContext context,
    required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(
          context: context, message: json.decode(response.body)['message']);
      break;
    case 500:
      showSnackBar(
          context: context, message: json.decode(response.body)['error']);
      break;
    default:
      showSnackBar(context: context, message: response.body);
      break;
  }
}
