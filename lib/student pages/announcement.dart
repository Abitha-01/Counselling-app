import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 219, 238, 253),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 156, 194, 224),
          title: const Text('Announcements'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: NotiList(),
      ),
    );
  }
}

class NotiList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('notis').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 164, 201, 231),
            ),
          );
        }
        final notis = snapshot.data?.docs ?? [];
        notis.sort((a, b) => b['date'].compareTo(a['date']));
        return ListView.builder(
          itemCount: notis.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    notis[index]['data'],
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    notis[index]['date'],
                    style: TextStyle(fontSize: 14.0),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _delete(context, notis[index].id);
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.black,
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
  await FirebaseFirestore.instance.collection('notis').doc(documentId).delete();
}
