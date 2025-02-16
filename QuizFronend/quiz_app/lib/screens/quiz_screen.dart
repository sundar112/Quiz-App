import 'dart:math'; // ✅ Import for shuffling
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/questions.dart'; // ✅ Import local questions data

import 'package:quiz_app/screens/background_image.dart';


class QuizScreen extends StatefulWidget {
  final String difficulty;

  final Function(bool) onQuizCompleted;
  const QuizScreen({required this.difficulty, required this.onQuizCompleted});

  

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List questions = [];
  int currentIndex = 0;
  int score = 0;
  String? selectedAnswer;
  bool answerSelected = false;

  void finishQuiz() {
  bool isPassed = score == questions.length; // ✅ User must get all correct
  widget.onQuizCompleted(isPassed); // ✅ Pass result to HomeScreen
  
}

/*************this part is for API calls if you want to fetch data from backend**************/
  // @override
  // void initState() {
  //   super.initState();
  //   fetchQuestions();
  // }

  // Future<void> fetchQuestions() async {
  //   try {
  //     final response = await http.get(Uri.parse('http://10.0.2.2:5000/questions?difficulty=${widget.difficulty}'));
  //     if (response.statusCode == 200) {
  //       List fetchedQuestions = json.decode(response.body);
  //       fetchedQuestions.shuffle(); // ✅ Shuffle the questions list
  //       setState(() {
  //         questions = fetchedQuestions;
  //       });
  //     } else {
  //       throw Exception('Failed to load questions');
  //     }
  //   } catch (e) {
  //     print('Error fetching questions: $e');
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text("Error"),
  //         content: Text("Unable to load questions. Please check your connection or try again later."),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("OK"),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  // }
  /*************this part is for API calls if you want to fetch data from backend**************/

  /*************this part is for local data call**************/
  void loadQuestions() {
  setState(() {
    questions = questionsData
        .where((q) => q['difficulty'] == widget.difficulty) // ✅ Filter by difficulty
        .toList();
    questions.shuffle(); // ✅ Randomize questions
  });
}
initState() {
  super.initState();
  loadQuestions(); // ✅ Load local data instead
}
/*************this part is for local data call**************/


  void checkAnswer(String answer) {
    if (answerSelected) return;

    setState(() {
      selectedAnswer = answer;
      answerSelected = true;
      if (answer == questions[currentIndex]['correctAnswer']) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        answerSelected = false;
      });
    } else {
      finishQuiz(); // ✅ Notify HomeScreen when quiz is completed
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Quiz Completed"),
          content: Text("Thank You for your participation \nYour Score: $score\nIncorrect: ${questions.length - score}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4E6),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: BackgroundImage(
                imagePath: "assets/dhammadigital-logo.png",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Quiz Level: ${widget.difficulty.toUpperCase()}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Question No ${currentIndex + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text("Score: ${score.toString().padLeft(2, '0')}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 49, 6, 6))),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text(
                    questions[currentIndex]['question'],
                    style: TextStyle(fontSize: 20, color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...questions[currentIndex]['options'].map<Widget>((option) {
                    bool isCorrect = option == questions[currentIndex]['correctAnswer'];
                    bool isSelected = option == selectedAnswer;

                    return GestureDetector(
                      onTap: answerSelected ? null : () => checkAnswer(option),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isCorrect ? const Color.fromARGB(117, 76, 175, 79) : const Color.fromARGB(115, 244, 67, 54))
                              : (answerSelected && isCorrect ? const Color.fromARGB(112, 76, 175, 79) : const Color.fromARGB(89, 224, 224, 224)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: answerSelected ? nextQuestion : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
    );
  }
}
