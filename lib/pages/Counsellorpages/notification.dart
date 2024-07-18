import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CounsellorNoti extends StatelessWidget {
  final TextEditingController _msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ANNOUNCEMENTS', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue.shade200,
      ),
      body: NotiList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade400,
      ),
    );
  }

  void _confirm(BuildContext context) async {
    DateTime now = DateTime.now();
    String date =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    String confirm = _msg.text;
    try {
      await FirebaseFirestore.instance.collection('notis').add({
        'data': confirm,
        'date': date,
      });
   
    } catch (e) {
      print('Error adding attendance: $e');
      
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _msg,
                decoration: InputDecoration(labelText: 'Enter your message here'),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _confirm(context);
                      Navigator.of(context).pop();
                    },
                    child: Text('Send', style: TextStyle(color: Colors.blue)),
                  ),
                  SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotiList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('noti').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }
        final noti = snapshot.data?.docs ?? [];
        noti.sort((a, b) => b['date'].compareTo(a['date']));
        return ListView.builder(
          itemCount: noti.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  title: Text(noti[index]['data']),
                  subtitle: Text(noti[index]['date']),
                  trailing: IconButton(
                    onPressed: () {
                      _delete(context, noti[index].id);
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void _delete(BuildContext context, String documentId) async {
  await FirebaseFirestore.instance.collection('noti').doc(documentId).delete();
}
