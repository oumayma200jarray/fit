import 'package:fit/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Pedometer extends StatelessWidget{
  //const Pedometer({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:  Colors.blue,
        brightness: Brightness.light,

      ),
      home: HomeScreen(),
      


    );
  }
}