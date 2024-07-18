
import 'package:first/student%20pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Studentbooking extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  String _selectedClass = 'S6'; // Default selected class
  String _selectedDepartment = 'ECE'; // Default selected department
  final TextEditingController _dateTimeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  final List<String> classOptions = [
    'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'
  ]; // Options for class dropdown
  final List<String> departmentOptions = [
    'ECE', 'IT', 'CSE', 'MECH', 'EEE'
  ]; // Options for department dropdown

  void _bookAppointment(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; // Return if the form is not valid
    }
    String name = _nameController.text;
    String dateTime = _dateTimeController.text;

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'name': name,
        'class': _selectedClass,
        'department': _selectedDepartment,
        'dateTime': dateTime,
      });

      _confirm(context); // Send confirmation only if booking is successful
      _dialog(context);

      // Show a success message or navigate to another screen
    } catch (e) {
      print('Error adding booking: $e');
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            height: 700,
            width: 600,
            child: Form(
              key: _formKey, // Assign the form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('BOOK YOUR APPOINTMENT', style: TextStyle(fontSize: 35)),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField(
                    value: _selectedClass,
                    items: classOptions.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _selectedClass = newValue;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Select your class',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your class';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField(
                    value: _selectedDepartment,
                    items: departmentOptions.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _selectedDepartment = newValue;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Select your department',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your department';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('Enter your preferred date', style: TextStyle(color: Colors.black, fontSize: 20)),
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
                            _dateTimeController.text = pickedDate.toString(); // Update the text field
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    child: Text('BOOK NOW', style: TextStyle(color: const Color.fromARGB(255, 251, 247, 247))),
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 7, 118, 228)),
                    onPressed: () {
                      _bookAppointment(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirm(BuildContext context) async {
    String confirm = 'You have a new appointment request';
    DateTime now = DateTime.now();
    String date = "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    try {
      await FirebaseFirestore.instance.collection('noti').add({
        'data': confirm,
        'date': date,
      });
      // Show a success message or navigate to another screen
    } catch (e) {
      print('Error adding attendance: $e');
      // Handle the error
    }
  }

  void _dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Your appointment request has been sent'),
              IconButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentHome()));
                },
                icon: Icon(Icons.done),
              ),
            ],
          ),
        );
      },
    );
  }
}
