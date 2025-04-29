import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String avatarName;
  final String avatarImagePath;
  final int userScore;
  final int badgesEarned;
 

  const ProfilePage(
      {super.key,
      required this.avatarName,
      required this.avatarImagePath,
      required this.userScore,
      required this.badgesEarned,
    
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   Color(0xFF444444),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,color: Colors.white70,fontSize: 30),),
        backgroundColor: Color(0xFF444444),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    avatarImagePath,
                    height: 200,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    avatarName,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                       color: Color.fromARGB(197, 255, 255, 255)
                      ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Score: $userScore',
              style: const TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),
            Text(
              'Badges Earned: $badgesEarned',
              style: const TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }
}