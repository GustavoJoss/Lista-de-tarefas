import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/repositories/todo_repository.dart';
import 'package:lista_de_tarefas/widgets/todo_list_iten.dart';
import 'package:lista_de_tarefas/models/todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
      todoRepository.saveTodoList(todos);
    });
  }


  void addTodo() {
    String text = todoController.text;
    if (text.isNotEmpty) {
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
    }else{
      setState(() {
        errorText = 'A tarefa não pode ser vazia!';
      });
    }
  }

  void clearTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Regar as plantas',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade300,
                            )
                          ),
                          labelStyle: TextStyle(
                            color: Colors.green.shade300,
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: addTodo,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListIten(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas pendentes',
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showClearTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                      ),
                      child: Text('Limpar Tudo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete (Todo todo){
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState((){
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);


    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('A tarefa ${todo.title} foi removida com sucesso!',
          style: TextStyle(color: Color(0xff060708)),),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: Colors.green.shade300,
            onPressed: (){
              setState(() {
                todos.insert(deletedTodoPos!, deletedTodo!);
              });
              todoRepository.saveTodoList(todos);
            },
          ),
          duration: const Duration(seconds: 5),
      ),
    );

    
  }
  void showClearTodosConfirmationDialog(){
      showDialog(context: context, 
        builder: (context) => AlertDialog(
          title: Text('Deletar todas as Tarefas?'),
          content: Text('Você tem certeza que deseja deletar todas as tarefas?'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green.shade300),
              child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  clearTodos();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Deletar'),
              ),
          ],
        ),
      );
    }
}