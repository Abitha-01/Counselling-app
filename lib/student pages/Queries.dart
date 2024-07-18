import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class QueryPage extends StatefulWidget {
  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  final TextEditingController _questionController = TextEditingController();
  Map<String, TextEditingController> _answerControllers = {};
Map<String, bool> _likes = {};
  void _postQuestion(String question) {
    if (question.isNotEmpty) {
      FirebaseFirestore.instance.collection('questions').add({
        'question': question,
        'timestamp': DateTime.now(),
      });
      _questionController.clear();
    }
  }

  void _postAnswer(String answer, String questionId) {
    if (answer.isNotEmpty) {
      FirebaseFirestore.instance.collection('answers').add({
        'answer': answer,
        'questionId': questionId,
        'timestamp': DateTime.now(),
      });
      _answerControllers[questionId]!.clear();
    }
  }

   void _likeQuestion(String questionId) {
    if (!_likes.containsKey(questionId)) {
      _likes[questionId] = true;
    } else {
      _likes[questionId] = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Color.fromARGB(255, 193, 225, 236),

        title: Text(
          'Queries',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 193, 225, 236),
      body: Column( 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Ask a question...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _postQuestion(_questionController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('questions')
              .orderBy('timestamp', descending: true)
              .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final questions = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    _answerControllers.putIfAbsent(
                      question.id,
                      () => TextEditingController(),
                    );
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question['question'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             SizedBox(height: 4),
                            Text(
                              'Posted on ${_formatDateTime(question['timestamp'] as Timestamp)}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 8),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('answers')
                                  .where('questionId', isEqualTo: question.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return SizedBox();
                                }
                                final answers = snapshot.data!.docs;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: answers
                                      .map(
                                        (answer) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Text(
                                            answer['answer'],
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                            ),
                             SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                  IconButton(
                                  icon: Icon(Icons.thumb_up),
                                  onPressed: () => _likeQuestion(question.id),
                                  color: _likes[question.id] ?? false ? Colors.blue : null,
                                ),
                                Text(
                                  _likes[question.id] ?? false ? 'Unlike' : 'Like',
                                  style: TextStyle(
                                    color: _likes[question.id] ?? false ? Colors.blue : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
   String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}