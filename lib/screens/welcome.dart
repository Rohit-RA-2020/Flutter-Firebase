import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late String email;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  late CollectionReference _collectionReference;

  @override
  void initState() {
    super.initState();

    email = widget.email;
    _collectionReference = FirebaseFirestore.instance.collection(email);
  }

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';

    if (documentSnapshot != null) {
      action = 'update';
      _taskController.text = documentSnapshot['task'];
      _hoursController.text = documentSnapshot['hours'].toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(labelText: 'Task'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _hoursController,
                  decoration: const InputDecoration(
                    labelText: 'Hours',
                  ),
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? task = _taskController.text;
                    final double? hours =
                        double.tryParse(_hoursController.text);

                    if (task != null && hours != null) {
                      if (action == 'create') {
                        await _collectionReference
                            .add({"task": task, "hours": hours});
                      }
                    }

                    if (action == 'update') {
                      await _collectionReference
                          .doc(documentSnapshot!.id)
                          .update({"task": task, "hours": hours});
                    }

                    _taskController.text = '';
                    _hoursController.text = '';

                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> delete(String taskid) async {
    await _collectionReference.doc(taskid).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('You have Deleted a task')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: StreamBuilder(
        stream: _collectionReference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnaphot) {
          if (streamSnaphot.hasData) {
            return ListView.builder(
              itemCount: streamSnaphot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnaphot.data!.docs[index];

                return Card(
                  child: ListTile(
                    title: Text(documentSnapshot['task']),
                    subtitle: Text(documentSnapshot['hours'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              onPressed: () {
                                _createOrUpdate(documentSnapshot);
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                delete(documentSnapshot.id);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            _createOrUpdate();
          } on FirebaseAuth catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.exit_to_app),
      ),
    );
  }
}
