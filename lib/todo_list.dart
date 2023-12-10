import 'dart:convert';

import 'package:flutter/material.dart';

import 'add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<dynamic> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              final id = todo['_id'];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(todo['title']),
                subtitle: Text(todo['description']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == "edit") {
                      navigateToEditPage(todo);
                    } else if (value == 'delete') {
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text('Edit'), value: 'edit'),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      )
                    ];
                  },
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text('Add Todo')),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    Navigator.push(context, route);
  }

  void navigateToEditPage(Map item) {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    final url = 'http://localhost:3000/todo/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  Future<void> fetchTodo() async {
    const url = 'http://localhost:3000/all-todos';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['todos'] as List;
      setState(() {
        todos = result;
      });
    }
  }
}
