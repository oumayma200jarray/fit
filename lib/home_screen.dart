
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StreamSubscription<PedestrianStatus>? _pedestrianSubscription;
  Timer? _stepTimer;
  String _status = "stopped";
  int _steps = 0;
  int _todaySteps = 0;
  bool _isWalking = false;
  bool _isPermissionGranted = false;
  bool _isLoading = false;

  Random _random = Random();
  DateTime? _walkingStartTime;
  double _walkingPace = 1.0;
  double _calories = 0;
  double _distance = 0;
  int _dailyGoal = 1000;
  List<Map<String, dynamic>> _weeklyData = [];

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _pedestrianSubscription?.cancel();
    _stepTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isLoading = true;
    });

    // Charger les données d'abord
    await _loadDailyData();
    await _loadTodaySteps();
    
    // Vérifier la permission ensuite
    final status = await Permission.activityRecognition.status;
    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
      _isLoading = false;
    });

    print("Permission status: $status");
    print("Steps loaded: $_steps");

    if (_isPermissionGranted) {
      await _setupMovementDetection();
    }
  }

  Future<void> _requestPermission() async { //demander la permission
    final status = await Permission.activityRecognition.request();
    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
    });
    
    if (_isPermissionGranted) {
      await _setupMovementDetection();
    }
  }

  Future<void> _setupMovementDetection() async { //configurer le détecteur de mouvement
    try {
      _pedestrianSubscription = Pedometer.pedestrianStatusStream.listen(
        (PedestrianStatus event) {
          print("Pedometer event: ${event.status}");
          _handleMovementChange(event.status);
        },
        onError: (error) {
          print("Pedometer error: $error");
          // Fallback manuel si le pedometer échoue
          _startManualStepCounting();
        }
      );
    } catch (e) {
      print("Error setting up movement detection: $e");
      _startManualStepCounting();
    }
  }

  void _handleMovementChange(String status) { //gérer le changement de statut
    setState(() {
      _status = status;
    });

    if (status == "walking" && !_isWalking) {
      _startWalkingSession();
    } else if (status != "walking" && _isWalking) {
      _stopWalkingSession();
    }
  }

  void _startWalkingSession() { //démarrer la session de marche (walking)
    setState(() {
      _isWalking = true;
      _status = "walking";
      _walkingStartTime = DateTime.now(); //date et heure de debut de marche
      _walkingPace = 0.85 + (_random.nextDouble() * 0.3);  //vitesse de marche
    });
    
    print("Starting walking session");
    _startManualStepCounting();
  }

  void _stopWalkingSession() { 
    setState(() {
      _isWalking = false;
      _walkingStartTime = null;
    });
    _stepTimer?.cancel();
    print("Stopping walking session");
  }

  void _startManualStepCounting() { 
    _stepTimer?.cancel();
    _stepTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isWalking) {
        setState(() {
          _steps++;
          _todaySteps++;
          _calculateMetrics();
        });
        _saveSteps();
        
        print("Step incremented: $_steps");
        
        // Changement aléatoire de rythme
        if (_random.nextDouble() < 0.3) {
          _walkingPace = 0.7 + (_random.nextDouble() * 0.6);
        }
      }
    });
  }

  void _calculateMetrics() { // calculer le nombre de calories et la distance changé
    _calories = _steps * 0.04;
    _distance = (_steps * 0.762) / 1000;
  }

  String _getDateKey() { //formater date
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _loadTodaySteps() async {
    try {
      final prefs = await SharedPreferences.getInstance();//Récupère l’instance de SharedPreferences (stockage local clé/valeur). await attend que l'instance soit prête
      final today = _getDateKey(); //obtenir la clé representant la date du jour ; today est la clé utilisée
      final lastDate = prefs.getString('lastDate') ?? '';

      print("Loading steps for date: $today");
      print("Last saved date: $lastDate");

      if (lastDate == today) {
        final savedSteps = prefs.getInt('steps_$today') ?? 0;
        print("Steps loaded from storage: $savedSteps");
        
        setState(() {
          _todaySteps = savedSteps;
          _steps = _todaySteps;
          _calculateMetrics();
        });
      } else {
        print("New day or no data, resetting to 0");
        setState(() {
          _todaySteps = 0;
          _steps = 0;
          _calculateMetrics();
        });
        await prefs.setString('lastDate', today);
        await prefs.setInt('steps_$today', 0);
      }
    } catch (e) {
      print("Error loading steps: $e");
      setState(() {
        _steps = 0;
        _todaySteps = 0;
        _calculateMetrics();
      });
    }
  }

  Future<void> _saveSteps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = _getDateKey();
      await prefs.setInt('steps_$today', _steps);
      await prefs.setString('lastDate', today);
      print("Steps saved: $_steps");
    } catch (e) {
      print("Error saving steps: $e");
    }
  }

  Future<void> _loadDailyData() async {  // recharge l'objectif quotidien
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _dailyGoal = prefs.getInt('dailyGoal') ?? 1000;
      });
      _loadWeeklyData();
    } catch (e) {
      print("Error loading daily data: $e");
      setState(() {
        _dailyGoal = 1000;
      });
    }
  }

  Future<void> _loadWeeklyData() async {  // recharge les pas de 7jours
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> weekData = [];
      
      for (int i = 6; i >= 0; i--) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        final steps = prefs.getInt('steps_$dateStr') ?? 0;
        
        weekData.add({
          'date': date,
          'steps': steps,
          'day': DateFormat('EEE').format(date).substring(0, 3), // "Mon" au lieu de "Monday"
        });
      }
      
      setState(() {
        _weeklyData = weekData;
      });
    } catch (e) {
      print("Error loading weekly data: $e");
    }
  }

  void _resetAllData() async {  // reinitialise les variables de pedometer
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = _getDateKey();
      
      await prefs.remove('lastDate');
      await prefs.remove('steps_$today');
      
      setState(() {
        _steps = 0;
        _todaySteps = 0;
        _calculateMetrics();
      });
      
      print("All data reset to zero");
    } catch (e) {
      print("Error resetting data: $e");
    }
  }

  void _showGoalDialog() { // affiche alerte pour ettre l'objectif des pas réalisé
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _dailyGoal.toString());
        return AlertDialog(
          title: Text("Set Daily Goal"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Daily Steps Goal",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newGoal = int.tryParse(controller.text) ?? 1000;
                setState(() {
                  _dailyGoal = newGoal;
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('dailyGoal', newGoal);
                Navigator.pop(context);
              },
              child: Text("Set Goal"),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDialog() {  // alert pour donner la permission
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Physical Activity Permission"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Step Counter App",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text("This app needs activity recognition permission to count your steps accurately."),
              SizedBox(height: 10),
              Text("Please allow access to physical activity."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Don't Allow"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _requestPermission();
              },
              child: Text("Allow"),
            ),
          ],
        );
      },
    );
  }

  void _simulateWalking() { // l'action effectué (en cliquant sur le bouton walk/stop)
    if (_isWalking) {
      _stopWalkingSession();
    } else {
      _startWalkingSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _dailyGoal > 0 ? (_steps / _dailyGoal).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Step Counter", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showGoalDialog,
            tooltip: "Set Daily Goal",
          ),
          if (_isPermissionGranted)
            IconButton(
              icon: Icon(Icons.directions_walk),
              onPressed: _simulateWalking,
              tooltip: "Simulate Walking",
            ),
          IconButton(
            icon: Icon(Icons.restart_alt),
            onPressed: _resetAllData,
            tooltip: "Reset Data",
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 20),
                  Text("Loading...", style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Main Progress Container
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[500]!, Colors.blue[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 12,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isWalking ? Icons.directions_walk : Icons.accessibility_new,
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(height: 15),
                              Text(
                                _steps.toString(),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "of $_dailyGoal Steps",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        decoration: BoxDecoration(
                          color: _isWalking ? Colors.green[400] : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          _isWalking ? 'WALKING' : 'STOPPED',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // Stats Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      icon: Icons.local_fire_department,
                      value: _calories.toStringAsFixed(1),
                      unit: 'cal',
                      color: Colors.orange[700]!,
                    ),
                    _buildStatCard(
                      icon: Icons.directions_walk,
                      value: _distance.toStringAsFixed(2),
                      unit: 'km',
                      color: Colors.purple[600]!,
                    ),
                    _buildStatCard(
                      icon: Icons.timer,
                      value: (_steps * 0.008).toStringAsFixed(0),
                      unit: 'min',
                      color: Colors.teal[600]!,
                    ),
                  ],
                ),

                SizedBox(height: 25),

                // Weekly Activity
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WEEKLY ACTIVITY",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _weeklyData.map((data) {
                            final maxSteps = _weeklyData.fold(1, (max, e) => e['steps'] > max ? e['steps'] : max);
                            final height = (data['steps'] / maxSteps * 100).clamp(10.0, 100.0);
                            final isToday = DateFormat('yyyy-MM-dd').format(data['date']) ==
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 25,
                                  height: height,
                                  decoration: BoxDecoration(
                                    gradient: isToday
                                        ? LinearGradient(
                                            colors: [Colors.blue[600]!, Colors.blue[400]!],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )
                                        : LinearGradient(
                                            colors: [Colors.grey[300]!, Colors.grey[400]!],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  data['day'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                    color: isToday ? Colors.blue[700] : Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  data['steps'].toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // Permission Button
                if (!_isPermissionGranted)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                      onPressed: _showPermissionDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fitness_center, size: 24),
                          SizedBox(width: 12),
                          Text(
                            "ENABLE STEP TRACKING",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            unit.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
/*
initState
   ↓
_checkPermissions
   ↓
Chargement données (SharedPreferences)
   ↓
Vérification permission
   ├── accordée → _setupMovementDetection (écoute les mouvements)
   └── pas accordée → bouton pour la demander
   ↓
En fonction du mouvement :
   ├── walking → _startWalkingSession → _startManualStepCounting
   └── stopped → _stopWalkingSession
   ↓
Chaque pas :
   ├── _steps++
   ├── _todaySteps++
   ├── _calculateMetrics()
   └── _saveSteps()*/
