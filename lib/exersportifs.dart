// ignore_for_file: non_constant_identifier_names

//import 'dart:core' as Parse;
import 'dart:core' show Future, List, dynamic, Uri, Exception, override, bool;

import 'package:flutter/material.dart';
import 'package:fit/ExerciseVideo.dart';
import 'package:fit/ApiService.dart';

class Exersportifs extends StatefulWidget{
  Exersportifs({super.key});
  @override
  State <Exersportifs>createState() => _ExersportifsState();}
  class _ExersportifsState extends State <Exersportifs>{
      List <ExerciseVideo> Exercicesdebutants=[];
      List <ExerciseVideo> Exercicesintermediaires=[];
      List <ExerciseVideo> Exercicesavancees=[];
      bool isLoadingvideo = true ;

  @override
  void initState() {
    super.initState();
    loadexercise();
  }
 
 Future<void> loadexercise() async {
  setState(() {
    isLoadingvideo = true;
  });

  final api = Apiservice();

  final debutants = await api.fetchDebutants();
  final intermediaires = await api.fetchIntermediaires();
  final avances = await api.fetchAvances();

  setState(() {
    Exercicesdebutants = debutants;
    Exercicesintermediaires = intermediaires;
    Exercicesavancees = avances;
    isLoadingvideo = false;
  });
}


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
      Text('debutant', style: TextStyle(fontSize: 15 , color: const Color.fromARGB(255, 14, 118, 147),fontStyle: FontStyle.italic,),),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal, 
        child: 
      ListView.builder(itemCount: Exercicesdebutants.length ,
      itemBuilder: (context, index) => Exercicesdebutants[index] ) ),
      SizedBox(height: 30,),
       Text('intermediaire', style: TextStyle(fontSize: 15 , color: const Color.fromARGB(255, 34, 163, 60), fontStyle: FontStyle.italic,)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal, 
        child: 
      ListView.builder(itemCount: Exercicesintermediaires.length ,
      itemBuilder: (context, index) => Exercicesintermediaires[index] ) ),
      SizedBox(height: 30,),
       Text('avancé', style: TextStyle(fontSize: 15 , color: const Color.fromARGB(255, 147, 100, 14),fontStyle: FontStyle.italic,),),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal, 
        child: 
      ListView.builder(itemCount: Exercicesavancees.length ,
      itemBuilder: (context, index) => Exercicesavancees[index] ) ),
    ],))
              ]),
            ) );
              
        }
      }