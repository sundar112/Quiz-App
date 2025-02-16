import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/questions.dart';
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
    bool isPassed = score == questions.length;
    widget.onQuizCompleted(isPassed);
  }

  void loadQuestions() {
    setState(() {
      questions = questionsData
          .where((q) => q['difficulty'] == widget.difficulty)
          .toList();
      questions.shuffle();
    });
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

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
      finishQuiz();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Quiz Completed"),
          content: Text("Thank You for your participation\nYour Score: $score\nIncorrect: ${questions.length - score}"),
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
                        Text(
                          "Score: ${score.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 49, 6, 6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              questions[currentIndex]['question'],
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                              ),
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
                                        ? (isCorrect
                                            ? const Color.fromARGB(117, 76, 175, 79)
                                            : const Color.fromARGB(115, 244, 67, 54))
                                        : (answerSelected && isCorrect
                                            ? const Color.fromARGB(112, 76, 175, 79)
                                            : const Color.fromARGB(89, 224, 224, 224)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    option,
                                    style: const TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: answerSelected ? nextQuestion : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
