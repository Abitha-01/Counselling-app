

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/pages/Counsellorpages/Answers.dart';
import 'package:first/pages/Counsellorpages/attendance.dart';

import 'package:first/pages/Counsellorpages/bookingreq.dart';
import 'package:first/pages/Counsellorpages/confirmed.dart';
import 'package:first/pages/Counsellorpages/notification.dart';
import 'package:first/pages/Studentlogin.dart';
import 'package:first/reportscreen.dart';

import 'package:flutter/material.dart';

class Counsellorhome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
         body: Container( decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
              
                const Color.fromARGB(255, 101, 146, 182),
                
                Colors.red.shade200,
              ],
            )
          ),
              child:Row( mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Column(
                   
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  
                  Column(
                      children: <Widget>[
                       
                        Text('CounselEase',style:TextStyle(fontSize:40,color:Color.fromARGB(255, 61, 5, 103),fontStyle:FontStyle.italic,)),
                        SizedBox(
                          height:25
                        ),
                     
                       Row(children:[ Text(
                          'Welcome counsellor!',
                          style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 66, 66, 67),
                          ),
                        ),
                         SizedBox(
                    width: 10,
                  ),Icon(Icons.emoji_emotions,color:Color.fromARGB(255, 66, 66, 67))
                       ]) ],
                    )
                  
                ],
              ),
              SizedBox(width:200),
                  Column(
                    
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                  
                 IconButton(onPressed:(){
                   Navigator.push(context,
                  MaterialPageRoute(builder:(context) => (CounsellorNoti())
                  )
                  );
                 }, icon: Icon(Icons.announcement,color:Color.fromARGB(242, 11, 10, 10),size:40)),
                   Text('Announcements'),
                   SizedBox(
                    height: 15,
                  ),
                 
                IconButton(onPressed: (){
                   Navigator.push(context,
                  MaterialPageRoute(builder:(context) => (BookingScreen())
                  )
                  );
                   
                  }, icon:  Icon(Icons.bookmark_add, color: const Color.fromARGB(255, 19, 16, 16),size:40)),
                  Text('Booking requests'),
                   SizedBox(
                    height: 15,
                  ),
                  IconButton(onPressed: (){
                   Navigator.push(context,
                  MaterialPageRoute(builder:(context) => (Confirmed())
                  )
                  );
                   
                  }, icon:  Icon(Icons.book, color: const Color.fromARGB(255, 19, 16, 16),size:40)),
                  Text('Confirmed Appointments'),
                   SizedBox(
                    height: 15,
                  ),
                   IconButton(onPressed:(){
                  Navigator.push(context,
                  MaterialPageRoute(builder:(context) => (Attendance())
                  )
                  );
                 }, icon: Icon(Icons.person,color:Color.fromARGB(242, 11, 10, 10),size:40)),
                   Text('Attendance record'),
                   SizedBox(
                    height: 15,
                  ),  
                   IconButton(onPressed:(){
                  Navigator.push(context,
                  MaterialPageRoute(builder:(context) => (ReportScreen())
                  )
                  );
                 }, icon: Icon(Icons.file_copy,color:Color.fromARGB(242, 11, 10, 10),size:40)),
                   Text('Report of students'),
                   SizedBox(
                    height: 15,
                  ),       
                             IconButton(onPressed: (){
                    Navigator.push(context,
                  MaterialPageRoute(builder:(context) => (AnswerPage())
                  )
                  );
                  }, icon:  Icon(Icons.question_answer_rounded, color: const Color.fromARGB(255, 23, 13, 13),size:40)),
                    Text('Queries'),
                   SizedBox(
                    height: 15,
                  ),
                  
                  IconButton(onPressed: (){
                    Navigator.push(context,
                  MaterialPageRoute(builder:(context) => (StudentLogin())
                  )
                  );
                 }, icon:Icon(Icons.logout, color: const Color.fromARGB(255, 19, 13, 13),size:40)),
                   Text('Log out')
                     
                 ] )
                ],

              ),
          
        ),
    

      )
    );
  }
}