import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/pages/Studentlogin.dart';
import 'package:first/student%20pages/Queries.dart';
import 'package:first/student%20pages/Studentbooking.dart';
import 'package:first/student%20pages/announcement.dart';
import 'package:first/student%20pages/music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StudentHome extends StatefulWidget {
   static String tag = 'login-page';
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  static String tag = 'homepage';
  final _num = TextEditingController();
  bool _isValidPhoneNumber(String value) {
    print('Phone number: $value');
    if (value.isEmpty) return false;
    bool isValid = RegExp(r'^[0-9]{10}$').hasMatch(value);
    print('Is valid phone number: $isValid');
    return isValid;
  }


  void _ecall(BuildContext context) async {
    String x = 'You have an emergency call request, call immediately    ';
    String num = _num.text;
   
    DateTime now = DateTime.now();
    String date =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    try {
      await FirebaseFirestore.instance.collection('noti').add({
        'data': x + num,
        'date': date,
      });
     
    } catch (e) {
      print('Error adding attendance: $e');
     
    }
  }

  void _ncall(BuildContext context) async {
    String y = 'You have a call request';
    String num = _num.text;
    DateTime now = DateTime.now();
    String date =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    try {
      await FirebaseFirestore.instance.collection('attendance').add({
        'data': y + num,
        'date': date,
      });
      
    } catch (e) {
      print('Error adding attendance: $e');
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                const Color.fromARGB(255, 101, 146, 182),
                Colors.red.shade200,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        'CounselEase',
                        style: TextStyle(
                          fontSize: 40,
                          color: Color.fromARGB(255, 61, 5, 103),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      // Solid text as fill.
                      Text(
                        'Your personal development app',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 66, 66, 67),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(width: 200),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (Announcement()),
                          ),
                        );
                      },
                      icon: Icon(Icons.announcement,
                          color: Color.fromARGB(242, 11, 10, 10), size: 40)),
                  Text('Notifications'),
                  SizedBox(
                    height: 15,
                  ),
                  IconButton(
                      onPressed: () {
                      showDialog(
  context: context,
  builder: (BuildContext context) {
    return  AlertDialog(
                    title: const Text('Calls'),
                    content: Padding(
                      padding: const EdgeInsets.only(bottom: 35),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: _num,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              setState(() {}); 
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter your number',
                              errorText: !_isValidPhoneNumber(_num.text)
                                  ? 'Invalid phone number'
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_isValidPhoneNumber(_num.text)) {
                                _ecall(context);
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter a valid phone number.'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(double.infinity, 50), 
                              padding: EdgeInsets.all(12.0),
                            ),
                            child: Text(
                              'EMERGENCY CALL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_isValidPhoneNumber(_num.text)) {
                                _ncall(context);
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter a valid phone number.'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(double.infinity, 50),
                              padding: EdgeInsets.all(12.0),
                            ),
                            child: Text(
                              'NORMAL CALL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
  },
);

                      },
                      icon: Icon(Icons.call,
                          color: Color.fromARGB(255, 19, 12, 12), size: 40)),
                  Text('Call'),
                  SizedBox(
                    height: 15,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (Studentbooking()),
                          ),
                        );
                      },
                      icon: Icon(Icons.book,
                          color: Color.fromARGB(255, 19, 16, 16), size: 40)),
                  Text('Book Appointment'),
                  SizedBox(
                    height: 15,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (QueryPage()),
                          ),
                        );
                      },
                      icon: Icon(Icons.question_answer_rounded,
                          color: Color.fromARGB(255, 23, 13, 13), size: 40)),
                  Text('Queries'),
                   SizedBox(
                    height: 15,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (HomePageMusic()),
                          ),
                        );
                      },
                      icon: Icon(Icons.music_note_outlined,
                          color: Color.fromARGB(255, 23, 13, 13), size: 40)),
                  Text('Medisongs'),
                  SizedBox(
                    height: 15,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (StudentLogin()),
                          ),
                        );
                      },
                      icon: Icon(Icons.logout,
                          color: Color.fromARGB(255, 19, 13, 13), size: 40)),
                  Text('Log out')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('tag', tag));
  }
}
