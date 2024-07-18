import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _report = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedClass = 'S6'; // Default selected class
  String _selectedDepartment = 'ECE';
  final List<String> classOptions = [
    'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'
  ]; // Options for class dropdown
  final List<String> departmentOptions = [
    'ECE', 'IT', 'CSE', 'MECH', 'EEE'
  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 238, 253),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 156, 194, 224),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by Name',
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {}); // Trigger rebuild on text change
          },
        ),
      ),
      body: ReportList(searchTerm: _searchController.text, nameController: _nameController),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReportDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new student report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              SizedBox(
                height: 15,
              ),
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
                    setState(() {
                      _selectedClass = newValue;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Select class',
                ),
              ),
              SizedBox(
                height: 15,
              ),
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
                    setState(() {
                      _selectedDepartment = newValue;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Select department',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _report,
                decoration: const InputDecoration(labelText: 'Fill the data'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_validateFields()) {
                  _addReport(context);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill all the fields.',
                        style: TextStyle(color: Colors.red), // Change text color to red
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.white, // Change background color to white
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool _validateFields() {
    return _nameController.text.isNotEmpty &&
        _report.text.isNotEmpty;
  }

  void _addReport(BuildContext context) async {
    String name = _nameController.text;
    String report = _report.text;
    
    try {
      await FirebaseFirestore.instance.collection('report').add({
        'name': name,
        'class': _selectedClass,
        'department': _selectedDepartment,
        'report': report,
        'date': DateTime.now(),
      });
      // Show a success message or navigate to another screen
    } catch (e) {
      print('Error adding report: $e');
      // Handle the error
    }
  }
}

class ReportList extends StatelessWidget {
  final String searchTerm;
  final TextEditingController nameController;

  ReportList({required this.searchTerm, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('report').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center( 
            child: CircularProgressIndicator(color: Color.fromARGB(255, 164, 201, 231)),
          );
        }
        final report = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: report.length,
          itemBuilder: (ctx, index) {
            final name = report[index]['name'] as String;
            final classs = report[index]['class'] as String;
            final department = report[index]['department'] as String;
            final reportText = report[index]['report'] as String;
            final bool shouldHighlight = searchTerm.isNotEmpty && name.toLowerCase().contains(searchTerm.toLowerCase());

            return ListTile(
              title: Text(
                '$name, $classs, $department',
                style: TextStyle(
                  fontWeight: shouldHighlight ? FontWeight.bold : FontWeight.normal,
                  color: shouldHighlight ? Colors.blue : Colors.black,
                ),
              ),
              subtitle: Text(reportText),
              onTap: () {
                nameController.text = name;
                // Get the context from the TextField associated with the nameController
                final textFieldContext = nameController;
                // Scroll to the corresponding field
                Scrollable.ensureVisible(textFieldContext as BuildContext,
                    alignment: 0.5, duration: Duration(milliseconds: 500));
              },
            );
          },
        );
      },
    );
  }
}
