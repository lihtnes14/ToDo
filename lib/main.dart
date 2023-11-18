import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/task.dart';
import './screens/homepage.dart';

void main() => runApp(ToDoListApp());

class ToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal, // Change to the desired fancy color
          hintColor: Colors.yellow[700],
          fontFamily: 'Lato',
          iconTheme: IconThemeData(
            color: Colors.teal, // Change color as needed
            size: 28, // Change size as needed
          ),
          appBarTheme: AppBarTheme(
            color: Colors.teal, // Change color as needed
            iconTheme: IconThemeData(
              color: Colors.white, // Change color as needed
              size: 22, // Change size as needed
            ),
          ),
        ),
        title: 'To Do List',
        home: Homepage(),
      ),
    );
  }
}
