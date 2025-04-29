import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ww/View/widgets/txtfld.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  // Controllers for the TextFormFields
  final TextEditingController _emailController = TextEditingController();
   
  reset()async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset(
                "assets/wordwise.png",
                height: 250,
                width: 250,
              ),
              const Text(
                textAlign: TextAlign.center,
                "FORGOT PASSWORD?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 70),
             
             
              Row(
                children: [
                  Icon(Icons.email,size: 33,color: Color(0xFF494013),),
                  Expanded(
                    flex: 15,
                    child: txfldd(
                      hnttxt: "E-mail",
                      controller: _emailController,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 80),
             Align(
              alignment: Alignment.center,
            
               child: Container(
                           decoration: BoxDecoration(
                
                color: const Color(0xFFEDE284)
                         ,
                           ),
                           height: 40,
                           width: 200, 
                           child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEDE284),
                          foregroundColor: Colors.brown,
                         
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                onPressed: reset,
                child: const Text(
                  textAlign: TextAlign.center,
                  "Send Link",
                  style: TextStyle(
                  
                         fontSize: 16,
                         color: Colors.brown,
                  ),
                ),
                           ),
                         ),
             ),
          
          
            
            ],
          ),
        ),
      ),
    );
  }
}
