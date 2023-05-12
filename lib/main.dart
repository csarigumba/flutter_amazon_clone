import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          appBarTheme: AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          colorScheme:
              const ColorScheme.light(primary: GlobalVariables.secondaryColor)),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello World!"),
        ),
        body: Column(
          children: [
            Center(
              child: const Text('Flutter Demo Home Page'),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Click Me"))
          ],
        ),
      ),
    );
  }
}
