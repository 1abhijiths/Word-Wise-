import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ww/View/pages/login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getUserEmail();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _soundEnabled = prefs.getBool('sound') ?? true;
    });
  }

  void _getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userEmail = user?.email ?? 'No email found';
    });
  }

  void _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = value;
    });
    await prefs.setBool('notifications', value);
  }

  void _toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = value;
    });
    await prefs.setBool('sound', value);
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: const Color(0xFFEDE284),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Email Section
          Card(
            color: const Color(0xFFFCF6DB),
            child: ListTile(
              leading: const Icon(Icons.email, color: Color(0xFF494013)),
              title: Text(
                'Email',
                style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF494013)),
              ),
              subtitle: Text(
                _userEmail,
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ),

          // Notifications Toggle
          SwitchListTile(
            title: Text(
              'Notifications',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF494013)),
            ),
            subtitle: Text(
              'Enable/Disable app notifications',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
            activeColor: const Color(0xFF494013),
          ),

          // Sound Toggle
          SwitchListTile(
            title: Text(
              'Sound',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF494013)),
            ),
            subtitle: Text(
              'Enable/Disable app sounds',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            value: _soundEnabled,
            onChanged: _toggleSound,
            activeColor: const Color(0xFF494013),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF494013),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}