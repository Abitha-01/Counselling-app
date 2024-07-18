import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
// ignore: unused_import
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:ui' as ui;

class Attendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 238, 253),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 156, 194, 224),
        title: const Text('Attendance Record'),
      ),
      body: AttendanceList(),
      
       floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final attendanceSnapshot = await FirebaseFirestore.instance.collection('attendance').get();
          final attendance = attendanceSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          _downloadPDF(context, attendance);
        },
        child: const Icon(Icons.download, color: Colors.black),
      ),
    );
  }

  Future<void> _downloadPDF(BuildContext context, List<Map<String, dynamic>> attendance) async {
    try {
      final pdf = pw.Document();
 final Set<String> uniqueRecords = {};
    for (var record in attendance) {
      final String attendanceRecord = 'Name: ${record['name']}, Class: ${record['class']}, Department: ${record['department']}, Attended on: ${record['date']}';
      if (!uniqueRecords.contains(attendanceRecord)) {  
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child:pw.Text(
                  attendanceRecord,
                  style: pw.TextStyle(fontSize: 16),
                ),
                 );
          },
        ),
      );
uniqueRecords.add(attendanceRecord);}}
      final pdfBytes = await pdf.save();
      final Uint8List pdfUint8List = Uint8List.fromList(pdfBytes);

      final blob = html.Blob([pdfUint8List]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "attendance_record.pdf")
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error downloading PDF: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to download PDF: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

}

class AttendanceList extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('attendance').orderBy('date', descending: true).snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 164, 201, 231),
            ),
          );
        }
        final attendance = snapshot.data?.docs.map((doc) => doc.data() as Map<String, dynamic>).toList() ?? [];
        return ListView.builder(
          itemCount: attendance.length,
          itemBuilder: (ctx, index) => ListTile(
            title: Row(
              children: [
                Text(attendance[index]['name']),
                Text(' , '),
                Text(attendance[index]['class']),
                Text(' , '),
                Text(attendance[index]['department']),
              ],
            ),
            subtitle: Row(
              children: [
                Text('Attended on:  '),
                Text(attendance[index]['date']),
              ],
            ),
          ),
        );
      },
    );
  }
}

