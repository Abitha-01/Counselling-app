import 'dart:js';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Confirmed extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  String _selectedClass = 'S3'; 
  String _selectedDepartment = 'ECE';
  final List<String> classOptions = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'];
  final List<String> departmentOptions = ['ECE', 'IT', 'CSE', 'MECH', 'EEE'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),centerTitle: true,
        backgroundColor: Colors.blue, 
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('confirmed').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data!.docs;
          final nextMonth = DateTime.now().add(Duration(days: 30));
          
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;
              final name = data['name'];
              final className = data['class'];
              final department = data['department'];
              final date = data['date']; 
              final formattedNextMonth = DateFormat('yyyy-MM-dd').format(nextMonth);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: $name',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Set text color
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text('Class: $className'),
                        SizedBox(height: 4.0),
                        Text('Department: $department'),
                        SizedBox(height: 4.0),
                        Text('Appointment date: $date'),
                        SizedBox(height: 4.0),
                        Text(
                          'Follow up on: $formattedNextMonth',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.green, // Set text color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAttendanceDialog(context),
        child: Icon(Icons.person),
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark Student Attendance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTextFieldWithHoverEffect(
                controller: _nameController,
                labelText: 'Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _buildDropdownButtonFormFieldWithHoverEffect(
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
                labelText: 'Select Class',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a class';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _buildDropdownButtonFormFieldWithHoverEffect(
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
                labelText: 'Select Department',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a department';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Date'),
                subtitle: Text('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _selectedDate = pickedDate;
                    _dateTimeController.text = pickedDate.toString();
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_validateInputs()) {
                  _attendance(context);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFieldWithHoverEffect({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
       // validator: validator,
      ),
    );
  }

  Widget _buildDropdownButtonFormFieldWithHoverEffect({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DropdownButtonFormField(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        validator: validator,
      ),
    );
  }

  DateTime _selectedDate = DateTime.now();

  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a name',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return false;
    }
    if (_selectedClass.isEmpty) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a class',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return false;
    }
    if (_selectedDepartment.isEmpty) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a department',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return false;
    }
    return true;
  }

  void _attendance(BuildContext context) async {
    String name = _nameController.text;
    String dateTime = _dateTimeController.text;
    try {
      await FirebaseFirestore.instance.collection('attendance').add({
        'name': name,
        'class': _selectedClass,
        'department': _selectedDepartment,
        'date': dateTime,
      });
      // Show a success message or navigate to another screen
    } catch (e) {
      print('Error adding attendance: $e');
      // Handle the error
    }
  }
}

