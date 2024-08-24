import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_tutorial/database/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Map<String, dynamic>> _journals = [];

  bool isLoading = true;

  void _refreshJournals() async {
    final data = await SqlHelper.getItems();
    setState(() {
      _journals = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    _refreshJournals();
    super.initState();
  }

  Future<void> _addItem() async {
    await SqlHelper.createItem(
      titleController.text,
      descriptionController.text,
    );
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SqlHelper.updateItem(
      id,
      titleController.text,
      descriptionController.text,
    );
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SqlHelper.deleteItem(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar
      ..showSnackBar(
        const SnackBar(
          content: Text('Successfully Deleted..'),
        ),
      );
    _refreshJournals();
  }

  void showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      titleController.text = existingJournal['title'];
      descriptionController.text = existingJournal['description'];
    }
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  if (id == null) {
                    await _addItem();
                  }
                  if (id != null) {
                    await _updateItem(id);
                  }
                  titleController.text = '';
                  descriptionController.text = '';
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: Text(id == null ? 'Add new' : 'Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          showForm(null);
        },
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: _journals.length,
              itemBuilder: (context, index) {
                final j = _journals[index];
                return ListTile(
                  title: Text(j['title']),
                  subtitle: Text(j['description']),
                  trailing: SizedBox(
                    width: 96,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showForm(j['id']);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteItem(j['id']);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
