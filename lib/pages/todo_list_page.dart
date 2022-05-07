import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/todo.dart';
import 'package:lista_tarefas/repositories/todo_repository.dart';
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

  String? errorText = null;

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

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
          textColor: const Color.fromARGB(255, 33, 102, 116),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
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
        content:
            const Text('A confirmação deste campo apagará todas as tarefas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Color.fromARGB(255, 33, 102, 116),
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
    todoRepository.saveTodoList(todos);
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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        hintText: 'Ex: Estudar flutter',
                        errorText: errorText,
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
                      bool verificationText = text.isEmpty || text[0] == ' ';

                      if (verificationText) {
                        setState(() {
                          errorText = 'O campo não pode ser vazio!';
                          todoController.clear();
                        });
                        return;
                      }

                      setState(() {
                        Todo newTodo = Todo(
                          title: text,
                          dateTime: DateTime.now(),
                        );
                        todos.add(newTodo);
                        errorText = null;
                      });
                      todoController.clear();
                      todoRepository.saveTodoList(todos);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding: const EdgeInsets.all(13),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 31, 114, 133),
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
                    child: const Text('Limpar tudo', style: TextStyle(color: Color.fromARGB(255, 33, 102, 116)),),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFFFFFFF),
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
