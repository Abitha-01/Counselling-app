import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Booking Requests'),centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: BookingList(),
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }
        final bookings = snapshot.data?.docs ?? [];
        if (bookings.isEmpty) {
          return Center(
            child: Text('No Requests'),
          );
        }
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (ctx, index) => ListTile(
            title: Text(bookings[index]['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${bookings[index]['class']}, ${bookings[index]['department']}'),
                Text('Preferred Date: ${bookings[index]['dateTime']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    _confirm(context, bookings[index].id, bookings[index]['name'], bookings[index]['class'], bookings[index]['department'], bookings[index]['dateTime']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    _reject(context,  bookings[index].id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _confirm(BuildContext context, String documentId, String name, String className, String department, String date) async {
   TimeOfDay selectedTime = TimeOfDay.now();
    String time = "${selectedTime.hour}:${selectedTime.minute}";
showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null && picked != selectedTime) {
                  selectedTime = picked;
                }
              },
              child: Text('Select Time'),
            ), 
              TextButton(
                onPressed: () {
                              AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Confirmed'),
                        
                        
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                 Navigator.of(context).pop();
                
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );

   DateTime now = DateTime.now();
  String datec = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  String confirm = 'Your appointment request has been confirmed on your preferred date at: ';
  try {
    await FirebaseFirestore.instance.collection('notis').add({
      'data': confirm + time,
      'date': datec,
      
    });
    await FirebaseFirestore.instance.collection('bookings').doc(documentId).delete();
  } catch (e) {
    print('Error adding attendance: $e');
  }

  try {
    await FirebaseFirestore.instance.collection('confirmed').add({
      'name': name,
      'class': className,
      'department': department,
      'date': date ,
    });

    await FirebaseFirestore.instance.collection('bookings').doc(documentId).delete();
  

  

   
  } catch (e) {
    print('Error confirming appointment: $e');
    // Handle the error
  }
}

void _reject(BuildContext context,String documentId) async {
  DateTime now = DateTime.now();
  String date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  final TextEditingController _dateTimeController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Rejected'),
            IconButton(
              icon: Icon(Icons.calendar_today),
              tooltip: 'Tap to open date picker',
             onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  _dateTimeController.text = pickedDate.toString(); 
                }
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
               
                _sendRejectionNotification(_dateTimeController.text,date, documentId);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    },
  );
}

void _sendRejectionNotification(String selectedDate,  String date, String documentId) async {
  String reject = 'Sorry, your appointment request has been rejected for the requested date. It can be rescheduled on: $selectedDate';
  try {
    await FirebaseFirestore.instance.collection('notis').add({
      'data': reject,
      'date': date,

    });
    await FirebaseFirestore.instance.collection('bookings').doc(documentId).delete();
  } catch (e) {
    print('Error adding attendance: $e');
  }
}