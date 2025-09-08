
import 'package:flutter/material.dart';

class AppColors extends StatelessWidget{
  const AppColors({super.key});
  static const Color primary = Color(0xFFF5EBFA);
  static const Color secondary = Color(0xFFE7DBEF);   
  static const Color accent = Color(0xFFA56ABD);      
  static const Color text = Color(0xFF6E3482);        
  static const Color background = Color(0xFF49225B); 
  @override
  Widget build (BuildContext context){
  return Positioned.fill(child:  Container(
        width:double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.accent,
              AppColors.text, 
              AppColors.background
            ],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
        ),));

}}