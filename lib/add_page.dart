import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleController.text = todo['title'];
      descriptionController.text = todo['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(isEdit ? 'Edit Todo' : 'Add Todo')),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: isEdit ? update : submit,
                child: Text(isEdit ? 'Update' : 'Submit'))
          ],
        ));
  }

  Future<void> update() async {
    final todo = widget.todo;
    final id = todo?['_id'];
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {"title": title, "description": description};

    final url = 'http://localhost:3000/todo/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(response.body);
  }

  Future<void> submit() async {
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {"title": title, "description": description};

    const url = 'http://localhost:3000/add-todo';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(response.body);
  }
}
