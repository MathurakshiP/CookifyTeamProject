
import 'package:flutter/material.dart';
import 'package:team_project/Screens/login_page.dart';
import 'package:team_project/Screens/search_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange[500],
      ),
      home: const LoginPage(),
    );

  }
}