import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List questions = [];
  int currentIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final response = await http.get(Uri.parse('http://192.168.1.180:5000/questions'));
    if (response.statusCode == 200) {
      setState(() {
        questions = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == questions[currentIndex]['correctAnswer']) {
      score++;
    }
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Quiz Completed"),
          content: Text("Your Score: $score / ${questions.length}"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(questions[currentIndex]['question']),
                ...questions[currentIndex]['options'].map((option) => ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      child: Text(option),
                    )),
              ],
            ),
    );
  }
}
