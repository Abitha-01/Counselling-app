
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/pages/Counsellorpages/counsellorhome.dart';
import 'package:first/pages/forget.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:first/student%20pages/homepage.dart';
import 'package:first/student%20pages/student%20sign%20up.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class StudentLogin extends StatefulWidget {
  static String tag = 'login-page';

  const StudentLogin({super.key});
  
   @override

  _Login createState() => _Login(); 
  
}
class _Login extends State<StudentLogin> {
 final user = FirebaseAuth.instance.currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  Future<User?> signin(String email, String password)async{
    
    User? user;
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email:email,
          password: password
      );
      user = userCredential.user;
      
    } on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
          print('No user found for that email.');
      }else if(e.code == 'wrong-password'){
        print('Wrong password provided.');
      }
    }
    return user;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child:Container(
          
          height:900,width:500,
        
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
               
            ],
          ),
        ),
      ),
    ));   
  }

  _header(context) {
    return  Column(
      children: [
        Text(
          "CounselEase",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),const SizedBox(height: 20),
        Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context) {
    final String predefinedEmail = 'counsellorgeci@gmail.com';
  final String predefinedPassword = 'password123';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller:emailController ,
          decoration:  InputDecoration(
              hintText: "Enter your email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: Color.fromARGB(255, 148, 173, 227).withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Color.fromARGB(255, 127, 185, 203).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
            
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async{
             String enteredEmail = emailController.text;
          String enteredPassword = passwordController.text;
          if (enteredEmail == predefinedEmail && enteredPassword == predefinedPassword) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Counsellorhome()));
          } else {   
            try{
               UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: enteredEmail,
                password: enteredPassword,
              );
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>StudentHome()));
           }catch (e) {
            print("Error signing in: $e");
            
          }
          }      
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color.fromARGB(255, 116, 203, 237),
          ),
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20,color:Colors.white),
          )
          )
      ]
    );
    
  }

   _forgotPassword(context) {
    return TextButton(
      onPressed: () {

         Navigator.push(context,
                  MaterialPageRoute(builder:(context) => PasswordResetPage()
                  )
                  );
      },
      child: const Text("Forgot password?",
        style: TextStyle(color: Color.fromARGB(255, 10, 102, 231)),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder:(context) => SignupPage()
                  )
                  );
            },
            child: const Text("Sign Up", style: TextStyle(color: Color.fromARGB(255, 10, 79, 239)),)
        )
      ],
    );
  }


}

 

