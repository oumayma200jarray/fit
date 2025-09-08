import 'package:flutter/material.dart';
import 'package:fit/ExerciseVideo.dart';

class Exersportifs extends StatefulWidget{
  Exersportifs({super.key});
  @override
  State <Exersportifs>createState() => _ExersportifsState();}
  class _ExersportifsState extends State <Exersportifs>{
      List <ExerciseVideo> Exercices=[];

    @override
    Widget build (BuildContext context){
      return Scaffold(appBar: AppBar(backgroundColor:const Color.fromARGB(255, 215, 141, 165), title:Text('Fitness',style: TextStyle(color:Colors.deepPurple,),)),
        body: Container(
          child: Stack( children: [
           SingleChildScrollView(
            child: Column(children: [
            Text('Introduction géneral',style: TextStyle(fontSize: 25, color: const Color.fromARGB(255, 130, 30, 139),fontWeight: FontWeight.bold )),
            Text(
              'Le sport joue un rôle essentiel dans notre vie. Il nous aide à préserver une bonne santé physique et mentale. '
              'Pour cette raison, il est important de le pratiquer régulièrement. Voici quelques activités sportives efficaces pour brûler des calories :',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
      SizedBox(height: 10),
      Text('🏃 Course à pied', style: TextStyle(fontSize: 16),),
      Text('🏋️‍♂️ Musculation', style: TextStyle(fontSize: 16)),
      Text('🤸 Yoga', style: TextStyle(fontSize: 16)),
      Text('🚴 Vélo', style: TextStyle(fontSize: 16)),
      Text('🧘 Méditation / Bien-être', style: TextStyle(fontSize: 16)),
      Text('🏊 Natation', style: TextStyle(fontSize: 16)),
      Text('⛹️ Basket', style: TextStyle(fontSize: 16)),
      Text('⚽ Football', style: TextStyle(fontSize: 16)),
      SizedBox(height: 10),
      Text('exemples des exercices ',style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 162, 9, 88) )),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal, 
        child: 
      ListView.builder(itemCount: Exercices.length ,
      itemBuilder: (context, index) => Exercices[index] ) ),

    ],))
              ]),
            ) );
              
        }
      }