
import 'package:first/pages/Studentlogin.dart';
import 'package:first/student%20pages/homepage.dart';
import 'package:first/student%20pages/student%20sign%20up.dart';
import 'package:flutter/material.dart';
 import 'package:firebase_core/firebase_core.dart'; 
 // ignore: unused_import
 import 'firebase_options.dart';
void main() async {
    
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options:FirebaseOptions(
   //add yours
    );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    StudentLogin.tag: (context) => StudentLogin(),
    StudentHome.tag: (context) => StudentHome(),
    SignupPage.tag: (context) => SignupPage(),
  };
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    return firebaseApp;
  }
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:StudentLogin()
 
    );
  }
}

