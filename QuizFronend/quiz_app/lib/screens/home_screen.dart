import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'menu_drawer.dart';
import 'background_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedLevel;
  int point = 0;
  Set<String> completedLevels = {}; // Track completed levels

  @override
  void initState() {
    super.initState();
    loadCompletedLevels();
    loadPoints(); // ✅ Load saved points
  }

  // ✅ Load completed levels from SharedPreferences
  Future<void> loadCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLevels = prefs.getStringList('completedLevels') ?? [];
    setState(() {
      completedLevels = savedLevels.toSet();
    });
  }

  // ✅ Load saved points from SharedPreferences
  Future<void> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      point = prefs.getInt('quizPoints') ?? 0; // Default to 0 if no points saved
    });
  }

  // ✅ Mark a level as completed and add points
  Future<void> markLevelCompleted(String level) async {
    if (!completedLevels.contains(level)) {
      setState(() {
        completedLevels.add(level);
        point += 5; // ✅ Add 5 points
      });

      // ✅ Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completedLevels', completedLevels.toList());
      await prefs.setInt('quizPoints', point);
    }
  }

  // ✅ Clear progress (reset points and completed levels)
  // Future<void> clearProgress() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('completedLevels');
  //   await prefs.remove('quizPoints'); // ✅ Reset points
  //   setState(() {
  //     completedLevels.clear();
  //     point = 0;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFE6F4E6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.red),
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
              const Text(
                "Points",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "$point", // ✅ Updated points displayed
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Quiz Level",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
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
              const Spacer(),
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
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Start Quiz",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              // ✅ Reset Progress Button (optional)
              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: clearProgress,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.black54,
              //     minimumSize: Size(double.infinity, 40),
              //   ),
              //   child: Text("Reset Progress"),
              // ),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isCompleted
              ? Colors.green
              : (selectedLevel == level ? Colors.blueAccent : Colors.grey[300]),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
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
