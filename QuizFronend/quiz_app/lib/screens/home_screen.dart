import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'menu_drawer.dart';
import 'background_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedLevel;
  Set<String> completedLevels = {}; // Track completed levels

  @override
  void initState() {
    super.initState();
    loadCompletedLevels(); // Load saved progress
  }

  // Load completed levels from SharedPreferences
  void loadCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLevels = prefs.getStringList('completedLevels') ?? [];
    setState(() {
      completedLevels = savedLevels.toSet();
    });
  }

  // Mark a level as completed and save to SharedPreferences
  void markLevelCompleted(String level) async {
    setState(() {
      completedLevels.add(level);
    });

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('completedLevels', completedLevels.toList());
  }

  // Clear progress (optional)
  void clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('completedLevels');
    setState(() {
      completedLevels.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFE6F4E6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.red),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BackgroundImage(
          imagePath: "assets/dhammadigital-logo.png",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Points",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "0",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Quiz Level",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Wrap(
                      spacing: 10,
                      children: [
                        levelOption("Level 1"),
                        for (int i = 2; i <= 10; i++) levelOption("Level $i"),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: selectedLevel == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              difficulty: selectedLevel!,
                              onQuizCompleted: (bool isPassed) {
                                if (isPassed) {
                                  markLevelCompleted(selectedLevel!);
                                }
                              },
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Start Quiz",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget levelOption(String level) {
    bool isCompleted = completedLevels.contains(level);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLevel = level;
        });
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isCompleted
              ? Colors.green
              : (selectedLevel == level ? Colors.blueAccent : Colors.grey[300]),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          level,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isCompleted
                ? Colors.white
                : (selectedLevel == level ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
