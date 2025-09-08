
import 'package:flutter/material.dart';
import 'package:fit/Space.dart';
import 'package:fit/buttons.dart';
import 'package:fit/InputDecoration.dart';


class Inscription extends StatefulWidget {
  const Inscription({super.key});
  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
        final _formKey = GlobalKey<FormState>();

  String langage = 'fr';
  Map<String, String> langageImages = {
    'fr': 'lib/assets/images/fr.jpg',
    'en': 'lib/assets/images/en.png',
    'ar': 'lib/assets/images/tn.jpg',
  };
  // Contrôleurs pour les champs
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  
  // Variables pour contrôler la visibilité des mots de passe
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  
 
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child:Center(
        child: Container(
          width: 300,
          child:SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  icon: Icon(Icons.arrow_back_ios_rounded)
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      langage = langage == 'fr' ? 'en' : 
                                langage == 'en' ? 'ar' : 'fr';
                    });
                  },
                  icon: Image.asset(
                    langageImages[langage] ?? 'lib/assets/images/fr.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Image.asset('lib/assets/images/tachkila_logo.png', width: 200, height: 100),
              Text('Inscription', style: TextStyle(fontWeight: FontWeight.bold)),
              Space.small,

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("tu as deja un compte"),
          Space.small,
          GestureDetector(
            onTap: () {
              // Navigation vers la page de connexion
              Navigator.pushNamed(
                context,'/Connexion');},
          
      
            child: Text(
             "se connecter",
              style: TextStyle(
                color: Colors.purpleAccent,
                decoration: TextDecoration.underline,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),    ),
                ],
              ), 
          Space.small,
          Form(
          key: _formKey,
          child: Column(
          children: [
          TextFormField(
            validator: (nom) {
              final v = nom?.trim() ?? '';
              if (v.isEmpty) return 'Nom requis';
              if (v.length < 3) return 'Au moins 3 caractères';
              if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(v)) return 'Nom invalide';
              return null;
            },
                controller: nomController,
                keyboardType: TextInputType.name,
                decoration: Deco('nom complet',Icon(Icons.people),null),
              ),
              Space.small,             
              // Champ numéro de téléphone avec validation
              TextFormField(
                validator: (telephone) {
                  final v = telephone?.trim() ?? '';
                  if (v.isEmpty) return 'Téléphone requis';
                  if (!RegExp(r'^[0-9+\-\s\(\)]{8,15}$').hasMatch(v)) return 'Numéro invalide';
                  return null;
                },
                controller: telephoneController,
                keyboardType: TextInputType.phone,
                decoration: Deco('telephone',Icon(Icons.phone), null),
              ),
              Space.small,
              // Champ email avec validation
              TextFormField(
                validator: (email) {
                  final v = email?.trim() ?? '';
                  if (v.isEmpty) return 'Email requis';
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(v)) return 'Email invalide';
                  return null;
                }, 
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: Deco('email',Icon(Icons.mail_outline),null),
                
              ),
              Space.small,
              TextFormField(
                validator: (password) {
                  final v = password?.trim() ?? '';
                  if (v.isEmpty) return 'Mot de passe requis';
                  if (v.length < 6) return 'Au moins 6 caractères';
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(v)) {
                    return 'Doit contenir minuscule, majuscule et chiffre';
                  }
                  return null;
                },
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isPasswordVisible,
                decoration:
                Deco('Mot De Passe',Icon(Icons.key), IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      isPasswordVisible = !isPasswordVisible;
                    },
                  ),),

                  ),
              Space.small,
              // Champ confirmation mot de passe avec validation et visibilité
              TextFormField(
                validator: (confirmPassword) {
                  final value = confirmPassword?.trim() ?? '';
                  if (value.isEmpty) return 'Confirmation requise';
                  if (value != passwordController.text.trim()) return 'Les mots de passe ne correspondent pas';
                  return null;
                },
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isConfirmPasswordVisible,
               decoration: Deco('confirm Password',Icon(Icons.key), null),
              ),])),
 Buttons( isInscription: true,text:'inscription', onPressed: 
 (){
               if (_formKey.currentState!.validate()) {
                  Navigator.pushNamed(context,'/Connexion');
                }
               }
),
SizedBox(height:30),Row(children:[
  Expanded(child:Divider(color:Colors.grey, thickness: 1, endIndent: 10,)),
  Text('OU',style: TextStyle(fontSize:10,),),
  Expanded(child:Divider(color:Colors.grey, thickness: 1, indent: 10,)),
SizedBox(height:15),]),
SizedBox()
]))))));}}

