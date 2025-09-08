import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseVideo extends StatefulWidget {
  final String videoUrl;
  final String text;
  final String title;
  final String description;

  ExerciseVideo({required this.videoUrl , required this.text , required this.description , required this.title});

  @override
  _ExerciseVideoState createState() => _ExerciseVideoState();
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  late VideoPlayerController _controller; // controleur video gére lecture,pause,arrét
                                         // late:initialise plus tard  

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)); //passer l'URL de video a ExerciseVideo et créer un controlleur
      _controller.initialize() //charger la video en memoire
      .then((_) {  // une fonction qui sera exécutée quand l’initialisation est terminée.
        setState(() {}); // Rafraîchir pour afficher la vidéo
        _controller.play(); // Lancer la vidéo automatiquement
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: 200,
          height: 150,
          child: Column( children:[ 
            Container( width: 200 , height: 100,
         child: _controller.value.isInitialized //verifie si la video est préte
        ? AspectRatio(  // si oui respecter le ratio de video : une fonction qui sera exécutée quand l’initialisation est terminée.
            aspectRatio: _controller.value.aspectRatio,  // recupére automatiquement largeur/hauteur de video pur qu'il ne soit pad deformé
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
          ),
          SizedBox(height: 10),
          Center(child: Text(widget.text, style: TextStyle(color: Colors.pink, fontSize: 20))),
          SizedBox(height: 10),
          Row(children: [
            Text(widget.title, style:
            TextStyle(color: Colors.purple,fontSize:18)),  
            Text(widget.description, style:
            TextStyle(color: Colors.black,fontSize:15)),

          ])])));
        
  }
}
