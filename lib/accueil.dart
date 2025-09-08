import 'package:flutter/material.dart';
import 'package:fit/Space.dart';
import 'package:fit/AppColors.dart';



class Accueil extends StatefulWidget{
  Accueil({super.key});
  
  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil>{
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(backgroundColor:const Color.fromARGB(255, 215, 141, 165), title:Text('Fitness',style: TextStyle(color:Colors.deepPurple,),)),
              
      body:Container(  width:double.infinity,
        height: double.infinity,
       child:   Stack( children:[
              AppColors(),

      SingleChildScrollView(
        child: Column(
             
          children: [
              
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                Icon(Icons.arrow_forward_ios_outlined),
                Spacer(),
                Text('Accueil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                Spacer(),
                Icon(Icons.notifications),
              ],
            ),
           
            Space.small,
          
                          
                          
              Row( mainAxisAlignment : MainAxisAlignment.center,
children: [
               Image.asset('lib/assets/images/etoile.png',width: 30,height: 30, color:const Color.fromARGB(255, 226, 142, 170),), 
               Space.small,
               Text(
                ' Bienvenue sur votre coach de remise en forme !',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                Space.small,
                Image.asset('lib/assets/images/etoile.png',width: 50,height: 50, color:const Color.fromARGB(255, 218, 130, 159),),
  ]
            ),
            SizedBox(height:10),
          
 
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'lib/assets/videos/pkg.gif',
                        width: 700,
                        height: 460,
                       fit: BoxFit.cover, 
                              alignment: Alignment.center,
// Fait que l'image apparaisse complètement
                   
                      ),
                    ),
             
            
            
            Space.small,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Prenez soin de votre corps et de votre santé grâce à notre application complète. Suivez vos pas, surveillez vos calories, accédez à des animations d\'exercices adaptés à votre niveau et bénéficiez de conseils de nutrition personnalisés. Que vous débutiez ou que vous soyez déjà actif, votre parcours commence ici. Bougez, progressez, restez motivé !',
                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 29, 4, 98)),
                textAlign: TextAlign.center,
              ),
            ),
          ]
        )
      )
       ])  ) );
          
          
  }
}

  
