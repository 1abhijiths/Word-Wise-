// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ww/View/pages/forgot.dart';
import 'package:ww/View/pages/signup.dart';
import 'package:ww/View/pages/home.dart'; 
import 'package:ww/View/widgets/txtfld.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // SignIn method
  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Navigator.pushReplacement(
          (context),
          MaterialPageRoute(
            builder: (context) => HomeScreen(), 
          ),
        );
      } catch (e) {
        String errorMessage = "An unexpected error occurred. Please try again.";
        if (e.toString().contains("user-not-found")) {
          errorMessage = "No user found with this email.";
        } else if (e.toString().contains("wrong-password")) {
          errorMessage = "Incorrect password. Please try again.";
        } else if (e.toString().contains("network-request-failed")) {
          errorMessage = "Network error. Please check your connection.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                "assets/wordwise.png",
                height: 250,
                width: 250,
              ),
            const Text(
              "LOGIN",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
              ),
            ),
              const SizedBox(height: 30),
              // Username Field
              Row(
                children: [
                  const Icon(
                    Icons.account_circle_rounded,
                   color: Color(0xFF494013),size: 32,
                  ),
                
                  Expanded(
                    
                    child: txfldd(
                      hnttxt: "Username",
                      controller: _usernameController,
                   
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Email Field
              Row(
                children: [
                  const Icon(
                    Icons.email,
                   color: Color(0xFF494013),size: 32,
                  ),
                 
                  Expanded(
                    child: txfldd(
                      hnttxt: "E-mail",
                      controller: _emailController,
                   
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Password Field
              Row(
                children: [
                  const Icon(
                    size: 32,color: Color(0xFF494013),
                    Icons.lock_person_rounded,
                   
                  ),
                  Expanded(
                    child: txfldd(
                      hnttxt: "Password",
                      controller: _passwordController,
                    
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Login Button
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEDE284),
                        foregroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 70,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Forgot()));
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    ),
                    child: const Text(
                      " Sign Up",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
