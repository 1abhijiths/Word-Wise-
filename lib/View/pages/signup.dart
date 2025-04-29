import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ww/View/widgets/txtfld.dart';
import 'package:ww/wrapper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Controllers for the TextFormFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Get.offAll(() => const Wrapper());
      } catch (e) {
        Get.snackbar("Sign Up Error", e.toString(),
            backgroundColor: Colors.redAccent, colorText: Colors.white);
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  "assets/wordwise.png",
                  height: 250,
                  width: 250,
                ),
                const Text(
                  "CREATE NEW ACCOUNT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 40),

                // Username Field
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 34,
                      color: Color(0xFF494013),
                    ),
                    Expanded(
                      flex: 15,
                      child: txfldd(
                        hnttxt: "Username",
                        controller: _usernameController,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Username is required";
                        //   }
                        //   return null;
                        // },
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
                      size: 33,
                      color: Color(0xFF494013),
                    ),
                    Expanded(
                      flex: 15,
                      child: txfldd(
                        hnttxt: "E-mail",
                        controller: _emailController,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "E-mail is required";
                        //   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+\$')
                        //       .hasMatch(value)) {
                        //     return "Enter a valid email";
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Password Field
                Row(
                  children: [
                    const Icon(
                      Icons.lock_person_rounded,
                      size: 33,
                      color: Color(0xFF494013),
                    ),
                    Expanded(
                      flex: 15,
                      child: txfldd(
                        hnttxt: "Password",
                        controller: _passwordController,
                        // obscureText: true,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Password is required";
                        //   } else if (value.length < 6) {
                        //     return "Password must be at least 6 characters long";
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 75),

                // Sign Up Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
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
                      onPressed: signup,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
