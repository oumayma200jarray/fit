import 'package:flutter/material.dart';
import 'package:fit/buttons.dart';
import 'package:fit/Space.dart';
import 'package:fit/InputDecoration.dart';
class Connexion extends StatefulWidget {
   Connexion({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  State<Connexion> createState() => _ConnexionState();}

class _ConnexionState extends State<Connexion>{
          final _formKey = GlobalKey<FormState>(); // ✅ Déclaration correcte

  String langage = 'fr';
  Map<String, String> langageImages = {
    'fr': 'lib/assets/images/fr.jpg',
    'en': 'lib/assets/images/en.png',
    'ar': 'lib/assets/images/tn.jpg',
  };
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  bool isPasswordVisible = false; //controler mot de passe
  bool isConfirmPasswordVisible = false;

  bool isEmailError = false;
  bool isPasswordError = false;
    bool isConfirmPasswordError = false;

 
  @override

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
          child:Center(
            child:Container(
              width:300,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ListTile(
                  leading: IconButton(
                   onPressed: () {
                      Navigator.pushNamed(context, '/inscription');
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
                  ),),
                  ),
                  Space.small,
                  Image.asset('lib/assets/images/tachkila_logo.png', width: 200, height: 100),
                  Text('Connexion', style: TextStyle(fontWeight: FontWeight.bold)),
                  Space.small,       
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("tu as deja un compte"),
                    Space.small,
                    GestureDetector(
                      onTap: () {
              // Navigation vers la page de connexion
                      Navigator.pushNamed(context,'/inscription');},
                      child: Text("inscription",
                      style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      ),
                      ),),
                      ],), 
                  Space.small,
                  Form(
                  key: _formKey,
                  child: Column(
                    children: [
                    TextFormField(
                      validator: (email) {
                        final v =  email?.trim() ?? '';
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
                      decoration: Deco('Mot De Passe',Icon(Icons.key), IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: (){   
                            isPasswordVisible = !isPasswordVisible;
                            } ,
                        ),),
                    ),
                    Space.medium,
                    Buttons(isInscription: false,text: 'Connexion',onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context,'/accueil');
                      }
                    })
                    ],
                  )),
                    ]) ),),)));}}
                        
                  
              