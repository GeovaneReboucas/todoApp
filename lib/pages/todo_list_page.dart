// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/todo.dart';
import 'package:lista_tarefas/widgets/Todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  final TextEditingController todoController = TextEditingController();

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${todo.title} foi removido com sucesso!',
            style: const TextStyle(
              color: Color(0xff060708),
            )),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00b5f4),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showDeletedAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content: const Text(
            'A confirmação deste campo apagará toda lista de tarefas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Color(0xFF1485F7),
            ),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              deleteAllTodos();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: Text('Limpar Tudo'),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(120, 71, 171, 215),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 45, left: 16, right: 16, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        // labelStyle: TextStyle(color: Colors.white),
                        // fillColor: Colors.white,
                        hintText: 'Ex: Estudar flutter',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 160, 160, 160)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String text = todoController.text;
                      bool verificationText = text.isNotEmpty && text[0] != ' ';

                      if (verificationText) {
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                        });
                      }
                      todoController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF1485F7),
                      padding: const EdgeInsets.all(13),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        delete: onDelete,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Você possui ${todos.length} tarefas pendentes',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: showDeletedAll,
                    child: const Text('Limpar tudo'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF1485F7),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
