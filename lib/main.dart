
import 'package:flutter/material.dart';
import 'package:fit/Inscription.dart';
import 'package:fit/Connexion.dart';
import 'package:fit/buttons.dart';
import 'package:fit/accueil.dart';
import 'package:fit/AppColors.dart';
import 'package:fit/Pedometer.dart';
import 'package:fit/exersportifs.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => const Fitness(),
        '/inscription': (context) => Inscription(),
        '/Connexion': (context) => Connexion(),
        '/accueil': (context) => Accueil(),
        '/exersportifs' : (context) => Exersportifs(),
        '/Pedometer' : (context) =>Pedometer(),
      },
    );
  }
}
class Fitness extends StatefulWidget{
  const Fitness({super.key});
  @override
  State<Fitness> createState() => _FitnessState();
}
class _FitnessState extends State<Fitness>{
@override
Widget build(BuildContext context){
  return Scaffold(appBar: AppBar(backgroundColor:const Color.fromARGB(255, 215, 141, 165), title:Text('Fitness',style: TextStyle(color:Colors.deepPurple,),)),
  body:Container( width: double.infinity , height: double.infinity ,
   child: Stack(  
children: [ AppColors(), Center(child:  SingleChildScrollView(  child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('Together for a better life',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 222, 131, 161)),),
SizedBox(height: 60),
ClipRRect(
  borderRadius: BorderRadius.circular(18),
child: Image.asset('lib/assets/images/fit.jpg',width: 700,
                        height: 460,
                       fit: BoxFit.cover, 
                              alignment: Alignment.center, ),),
SizedBox(height: 30),
Buttons(isInscription: true, text: 'Inscription',onPressed:(){
  Navigator.pushNamed(context, '/Pedometer');
}),
 const SizedBox(height: 20), 

Buttons(isInscription: false, text: 'Connexion',onPressed:(){
  Navigator.pushNamed(context, '/accueil'); 
}),
   const SizedBox(height: 40),
   ]))))])));
  
}
}