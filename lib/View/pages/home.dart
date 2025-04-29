// ignore_for_file: use_build_context_synchronously, avoid_print, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ww/View/pages/badges.dart';
import 'package:ww/View/pages/game1_home.dart';
import 'package:ww/View/pages/imagescanning.dart';
import 'package:ww/View/pages/keywordgiving.dart';
import 'package:ww/View/pages/login.dart';
import 'package:ww/View/pages/profile.dart';
import 'package:ww/View/pages/word_of_day.dart'; // Import Word of Day page
import 'package:ww/View/pages/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool showAvatarSelection =
      true; // Control avatar selection pop-up, changed to true initially.
  String selectedAvatarName = ''; // To store selected avatar name
  String selectedAvatarImagePath =
      ''; // To store selected avatar image path
  int userScore = 0; // Load from shared preferences
  int badgesEarned = 0;

  // Sign out method
  Future<void> signout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-out failed: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data on initialization
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatarName = prefs.getString('avatarName') ??
          ''; // Default avatar name
      selectedAvatarImagePath = prefs.getString('avatarImagePath') ??
          ''; // Default avatar image
      userScore = prefs.getInt('userScore') ?? 0;
      badgesEarned = prefs.getInt('badgesEarned') ?? 0;
      showAvatarSelection = prefs.getBool('showAvatarSelection') ??
          true; // Load the showAvatarSelection flag.
    });
    //moved the popup call here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showAvatarSelection) {
        _showAvatarSelectionPopup(context);
      }
    });
  }

  // Save user data to shared preferences
  Future<void> _saveUserData(
      String avatarName, String avatarImagePath, int score, int badges,
      {bool? showAvatarSelection}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarName', avatarName);
    await prefs.setString('avatarImagePath', avatarImagePath);
    await prefs.setInt('userScore', score);
    await prefs.setInt('badgesEarned', badges);
    if (showAvatarSelection != null) {
      await prefs.setBool(
          'showAvatarSelection', showAvatarSelection); // Save the flag
    }
    // No need to call setState here, it will be called in _buildAvatarCard and Game1Home
  }

  void _showAvatarSelectionPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Define a list of colors for the cards
        final List<Color> cardColors = [
       const Color(0xFF8AB4F8), // Card color 1
          const Color(0xFF90CAF9), // Card color 2
          const Color(0xC2E8FF), // Card color 3
          const Color(0xA9785DFFF), // Card color 4
          const Color.fromARGB(149, 5, 110, 175),
          Color(0xFFF5D090), // Card color 5
          const Color(0x0C2E4C), // Card color 6
          // Card color 7
          Color(0xFF444444), // Card color 8
          const Color(0xA3C6FFFF),
        ];

        return Container(
          height: 500,
          color: Colors.grey, // Container color
          child: PageView(
            children: [
              _buildAvatarCard(
                  context, 'Nightblade', 'assets/avatar1.png', cardColors[0]),
              _buildAvatarCard(
                  context, 'Alpha Shade', 'assets/avatar2.png', cardColors[1]),
              _buildAvatarCard(context, 'Shadow Sorcerer', 'assets/avatar3.png',
                  cardColors[2]),
              _buildAvatarCard(
                  context, 'Swift Fin', 'assets/avatar4.png', cardColors[3]),
              _buildAvatarCard(context, 'Mountain Might', 'assets/avatar5.png',
                  cardColors[4]),
              _buildAvatarCard(
                  context, 'Inferno Ire', 'assets/avatar6.png', cardColors[5]),
              _buildAvatarCard(
                  context, 'Astral Ape', 'assets/avatar7.png', cardColors[6]),
              _buildAvatarCard(
                  context, 'Midnight Maw', 'assets/avatar8.png', cardColors[7]),
              _buildAvatarCard(
                  context, 'Howling Hex', 'assets/avatar9.png', cardColors[8]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarCard(BuildContext context, String avatarName,
    String imagePath, Color cardColor) {
  return GestureDetector(
    onTap: () {
      // Handle avatar selection logic here
      print('Avatar selected: $avatarName');
      if (mounted) {
        setState(() {
          showAvatarSelection = false;
          selectedAvatarName = avatarName;
          selectedAvatarImagePath = imagePath;
          _saveUserData(avatarName, imagePath, userScore, badgesEarned,
              showAvatarSelection: false);
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context); // Close the bottom sheet after rebuild
      });
    },
    child: Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text('Choose your avatar',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(186, 255, 255, 255),
                    fontFamily: 'Poppins')),
            const SizedBox(height: 80),
            Image.asset(imagePath, height: 150),
            const SizedBox(height: 8),
            Text(avatarName,
                style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(213, 255, 255, 255),
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.home_rounded,
                            size: 38, color: Color(0xFF494013)),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                            avatarName: selectedAvatarName,
                                            avatarImagePath:
                                                selectedAvatarImagePath,
                                            userScore: userScore,
                                            badgesEarned: badgesEarned,
                                          ))).then((value) {
                                _loadUserData();
                              });
                            },
                            child: const Icon(Icons.account_circle_rounded,
                                size: 37, color: Color(0xFF494013))),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BadgesPage()),
                              );
                            },
                            child: const Icon(Icons.shield,
                                size: 32, color: Color(0XFF494013))),
                       InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  },
  child: const Icon(Icons.settings_rounded,
      size: 34, color: Color(0XFF494013))
)
                      ],
                    ),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE284),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Image.asset('assets/search1.png'),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ImagePage()),
                  );
                },
                child: const Icon(Icons.add_circle_rounded,
                    size: 60, color: Color(0XFF494013)),
              ),
              const SizedBox(height: 15),
              const Text('Upload your text to summarize',
                  style: TextStyle(fontFamily: 'Poppins')),
              const SizedBox(height: 200),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Game1Home(onScoreUpdate: (int newScore) {
                                  _updateScore(newScore);
                                }, onBadgeUpdate: (int newBadgeCount) {
                                  _updateBadgeCount(newBadgeCount);
                                }),
                              )).then((value) {
                            _loadUserData();
                          });
                        },
                        child: Image.asset('assets/icon1.png',height: 45,)
                      ),
                       InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WordOfDayApp()));
                        },
                        child: Image.asset('assets/icon2.png',height: 50,)),
                      InkWell(
                           onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FactCheckPage()),
                        );
                      },
                        child: Image.asset('assets/icon3.png',height: 45,))
                            
                    ],
                  ),
                  width: double.infinity,
                  height: 60,
                  
                  decoration: BoxDecoration(
                    color: const Color(0XFFFCF6DB),
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    boxShadow: [ // Add a shadow for depth
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateScore(int newScore) {
    setState(() {
      userScore = newScore;
    });
    _saveUserData(
        selectedAvatarName, selectedAvatarImagePath, userScore, badgesEarned);
  }

  void _updateBadgeCount(int newBadgeCount) {
    setState(() {
      badgesEarned = newBadgeCount;
    });
    _saveUserData(
        selectedAvatarName, selectedAvatarImagePath, userScore, badgesEarned);
  }
}

