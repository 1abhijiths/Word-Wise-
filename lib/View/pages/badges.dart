import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  int userScore = 0;
  List<Badge> badges = [
    Badge(
      color: Color(0xFFFFD230),
      title: 'Wordling',
      imagePath: 'assets/badge4.png',
    ),
     Badge(
      color: Color(0xFFFFB100),
      title: 'Budding Bard',
      imagePath: 'assets/badge1.png',
    ),
    Badge(
      color: Color(0xFFB1A1ED),
      title: 'Word Cool',
      imagePath: 'assets/badge2.png',
    ),
       Badge(
      color: Color(0xFFDE0F3F),
      title: 'Word Wielder',
      imagePath: 'assets/badge8.png',
    ),
    Badge(
      color: Color(0xFF00B0FF),
      title: 'Verbal Virtuoso',
      imagePath: 'assets/badge3.png',
    ),
    Badge(
      color: Color(0xFF945ACB),
      title: 'Word Voyager',
      imagePath: 'assets/badge6.png',
    ),
    // Add more badges as needed
  ];

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userScore = prefs.getInt('userScore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor:Color(0xFFF5EEBF),
      //   title: const Text(
      //        'BADGES AND TITLES',
      //       style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Color(0xFF2169AC),fontStyle: FontStyle.italic,fontFamily: 'Poppins'),
      //      ),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Column(
          children: [
           SizedBox(height: 10),
                       Image.asset('assets/won1.png', height: 150),

             const Text(
               'BADGES AND TITLES',
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Color(0xFF494013)),
             ),
             
           
          
         
            //const SizedBox(height: 30.0),
            Expanded(  
              child: ListView.builder(
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  return BadgeCard(
            
                    badge: badges[index],
                    unlocked: userScore >= (10*(index+1)), // Unlock logic
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Badge {
  final String title;
  final String imagePath;
  final Color color;

  Badge({required this.title, required this.imagePath,required this.color});
}

class BadgeCard extends StatelessWidget {
  final Badge badge;
  final bool unlocked;
 

   BadgeCard({super.key, required this.badge, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15.0),
      color: unlocked ? badge.color : Colors.grey[300], // Grey if locked
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              badge.imagePath,
              height: 100,
              color: unlocked ? null : Colors.grey, // Grey image if locked
            ),
            const SizedBox(height: 8.0),
            Text(
              badge.title,
              style: const TextStyle(fontSize: 15.0,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Poppins'),
            ),
            if (!unlocked)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Locked'),
              ),
          ],
        ),
      ),
    );
  }
}
