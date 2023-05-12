import 'package:amazon_clone_tutorial/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';

// Create ongenerate route function
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  // Get arguments passed in while calling Navigator.pushNamed
  final args = settings.arguments;

  switch (settings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AuthScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
