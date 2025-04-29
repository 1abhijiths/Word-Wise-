import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ww/View/pages/rightans.dart';
import 'package:ww/View/pages/wrongans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game1Home extends StatefulWidget {
  const Game1Home({super.key,required this.onScoreUpdate, // Add this
      required this.onBadgeUpdate});

      final Function(int) onScoreUpdate; // Add this
  final Function(int) onBadgeUpdate; // Add this

  @override
  State<Game1Home> createState() => _Game1HomeState();
}

class _Game1HomeState extends State<Game1Home> {
  late Map<String, dynamic> currentWord = {};
  late List<String> shuffledOptions = [];
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  int userScore = 0;
  int badgesEarned=0;
  List<Badge> badges = [
    Badge(
      color: Color(0xFFFFD230),
      title: 'Wordling',
      imagePath: 'assets/badge4.png',
      unlockScore: 10,
      
    ),
    Badge(
    color:  Color(0xFFF5D090), 
       title: 'Budding Bard',
      imagePath: 'assets/badge1.png',
      unlockScore: 20,
    ),
    Badge(
       color: Color(0xFFB1A1ED),
      title: 'Word Cool',
      imagePath: 'assets/badge2.png',
      unlockScore: 30,
    ),
    Badge(
     color:  Color(0xFFF5D090), 
        title: 'Word Wielder',
      imagePath: 'assets/badge8.png',
      unlockScore: 40,
    ),
      Badge(
           color:   const Color(0xFF90CAF9), 
       title: 'Verbal Virtuoso',
      imagePath: 'assets/badge3.png',
      unlockScore: 50,
    ),
      Badge(
        color: Color(0xFFB1A1ED),
title: 'Word Voyager',
      imagePath: 'assets/badge6.png',
      unlockScore: 130,
    ),
  ];

    @override
  void initState() {
    super.initState();
    _loadGameData(); //changed to _loadGameData
  
  }

  Future<void> _loadGameData() async {
    // Load score and badges earned
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userScore = prefs.getInt('userScore') ?? 0;
      badgesEarned = prefs.getInt('badgesEarned') ?? 0; // Load badges earned
    });
    _loadNewWord();
  }

   Future<void> _saveGameData() async {
    //save score and badges earned
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userScore', userScore);
    await prefs.setInt('badgesEarned', badgesEarned); // Save badges earned
  }

  Future<void> _loadNewWord() async {
  setState(() {
    isLoading = true;
  });

  try {
    final QuerySnapshot wordSnapshot =
        await _firestore.collection('vocabulary').get();
    final List<QueryDocumentSnapshot> wordDocs = wordSnapshot.docs;

    if (wordDocs.isNotEmpty) {
      final random = Random();
      final currentDoc = wordDocs[random.nextInt(wordDocs.length)];
      currentWord = currentDoc.data() as Map<String, dynamic>;

      List<String> options = [currentWord['meaning']]; // Initialize with the correct meaning

      while (options.length < 4) {
        final otherDoc = wordDocs[random.nextInt(wordDocs.length)];
        final otherWord = otherDoc.data() as Map<String, dynamic>;
        if (!options.contains(otherWord['meaning'])) { // Check if the meaning already exists
          options.add(otherWord['meaning']);
        }
      }

      shuffledOptions = List<String>.from(options)..shuffle();
    } else {
      print('No words found in the database.');
      currentWord = {'word': 'Default', 'meaning': 'Default meaning'};
      shuffledOptions = [
        'Option 1',
        'Option 2',
        'Option 3',
        'Default meaning'
      ];
    }
  } catch (e) {
    print('Error loading words: $e');
    currentWord = {'word': 'Error', 'meaning': 'Error loading data'};
    shuffledOptions = [
      'Option 1',
      'Option 2',
      'Option 3',
      'Error loading data'
    ];
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  void _checkAnswer(String selectedOption) {
    if (selectedOption == currentWord['meaning']) {
      userScore += 10;
      _saveGameData();
      _checkBadgeUnlock();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Rightans(
            onNextQuestion: _loadNewWord,
            userScore: userScore,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Wrongans(),
        ),
      );
    }
  }

  void _checkBadgeUnlock() {
    for (var badge in badges) {
      if (userScore == badge.unlockScore) {
         
          _showBadgeUnlockedPopup(badge);
          badgesEarned++;
          _saveGameData(); // Save badges earned
        
      }
    }
  }

  void _showBadgeUnlockedPopup(Badge badge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: badge.color,
          title: Center(child: const Text('Badge Unlocked!',style: TextStyle(fontWeight: FontWeight.bold),)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(badge.imagePath, height: 100),
              const SizedBox(height: 10),
              Text('You unlocked the ${badge.title}!',style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK',style: TextStyle(fontSize: 20),),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(height: 10,),
                  Center(child: Image.asset("assets/whyguy.png")),
                  //const SizedBox(height: 40),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/quesbox.png"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "What is the meaning of '${currentWord['word']}'?",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: shuffledOptions
                            .map((option) => AnswerOption(
                                  text: option,
                                  isCorrect: option == currentWord['meaning'],
                                  onSelect: _checkAnswer,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final Function(String) onSelect;

  const AnswerOption(
      {super.key,
      required this.text,
      required this.isCorrect,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(text),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}

class Badge {
  final String title;
  final String imagePath;
  final int unlockScore;
  final Color color;

  Badge({required this.title, required this.imagePath, required this.unlockScore,required this.color});
}