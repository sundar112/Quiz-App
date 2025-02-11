import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class QuizScreen extends StatefulWidget {
//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   List questions = [];
//   int currentIndex = 0;
//   int score = 0;
//   String? selectedAnswer;

//   @override
//   void initState() {
//     super.initState();
//     fetchQuestions();
//   }

//   Future<void> fetchQuestions() async {
//     final response = await http.get(Uri.parse('http://192.168.1.180:5000/questions'));
//     if (response.statusCode == 200) {
//       setState(() {
//         questions = json.decode(response.body);
//       });
//     } else {
//       throw Exception('Failed to load questions');
//     }
//   }

//   void checkAnswer() {
//     if (selectedAnswer == questions[currentIndex]['correctAnswer']) {
//       score++;
//     }

//     if (currentIndex < questions.length - 1) {
//       setState(() {
//         currentIndex++;
//         selectedAnswer = null;
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text("Quiz Completed"),
//           content: Text("Correct: $score\nIncorrect: ${questions.length - score}"),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFE6F4E6),
//       body: questions.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       "Quiz: name Buddha Jeewani",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Level Easy", style: TextStyle(fontSize: 16)),
//                       Text("Score: ${score.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     "Question No ${currentIndex + 1}",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     questions[currentIndex]['question'],
//                     style: TextStyle(fontSize: 18, color: Colors.blue.shade900, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 20),
//                   ...questions[currentIndex]['options'].map<Widget>((option) {
//                     return RadioListTile(
//                       title: Text(option),
//                       value: option,
//                       groupValue: selectedAnswer,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedAnswer = value.toString();
//                         });
//                       },
//                     );
//                   }).toList(),
//                   Spacer(),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: selectedAnswer == null ? null : checkAnswer,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                         minimumSize: Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                       child: Text(
//                         "Next",
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

class QuizScreen extends StatefulWidget {
  final String difficulty; // Added difficulty parameter

  QuizScreen({required this.difficulty});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List questions = [];
  int currentIndex = 0;
  int score = 0;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
    final response = await http.get(Uri.parse('http://192.168.1.180:5000/questions?difficulty=${widget.difficulty}'));
    if (response.statusCode == 200) {
      setState(() {
        questions = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load questions');
    }
  } catch (e) {
    print('Error fetching questions: $e');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("Unable to load questions. Please check your connection or try again later."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }
  }

  void checkAnswer() {
    if (selectedAnswer == questions[currentIndex]['correctAnswer']) {
      score++;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Quiz Completed"),
          content: Text("Correct: $score\nIncorrect: ${questions.length - score}"),
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
      backgroundColor: Color(0xFFE6F4E6),
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Quiz Level: ${widget.difficulty.toUpperCase()}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Score: ${score.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Question No ${currentIndex + 1}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    questions[currentIndex]['question'],
                    style: TextStyle(fontSize: 18, color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ...questions[currentIndex]['options'].map<Widget>((option) {
                    return RadioListTile(
                      title: Text(option),
                      value: option,
                      groupValue: selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          selectedAnswer = value.toString();
                        });
                      },
                    );
                  }).toList(),
                  Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: selectedAnswer == null ? null : checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Future<void> fetchQuestions() async {
  
}


