

import 'package:flutter/material.dart';

class Rightans extends StatelessWidget {
  final VoidCallback onNextQuestion;
  final int userScore;

  const Rightans({super.key, required this.onNextQuestion, required this.userScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/right.png", height: 300),
            const SizedBox(height: 10),
            const Text(
              'You got it right!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E5BB2),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Score: $userScore',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onNextQuestion();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Next Question",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}