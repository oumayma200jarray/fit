import 'package:flutter/material.dart';

class Buttons extends StatelessWidget{
  Buttons({super.key,required this.isInscription,required this.text,required this.onPressed });
 bool isInscription=true;
  final String text;
  final Function() onPressed;
 
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = (isInscription) 
        ? const Color.fromARGB(255, 149, 108, 220) 
        : const Color.fromARGB(255, 174, 93, 162);
    Color secondaryColor = (isInscription)
        ? const Color.fromARGB(255, 74, 9, 118)
        : const Color.fromARGB(255, 15, 10, 80);

    return SizedBox(
      width: 200,
      height: 50,
    
      child: ElevatedButton( onPressed:onPressed  , child: Text(text,style: TextStyle(color:secondaryColor)) ,style:ElevatedButton.styleFrom(backgroundColor: primaryColor),));
    
  }
}

