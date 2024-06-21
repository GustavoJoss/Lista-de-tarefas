import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/models/todo.dart';

class TodoListIten extends StatefulWidget {
  const TodoListIten({Key? key, required this.todo, required this.onDelete}) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  State<TodoListIten> createState() => _TodoListItenState();
}

class _TodoListItenState extends State<TodoListIten> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Deletar',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (context) {
              widget.onDelete(widget.todo);
            },
          ),
        ],
      ),
      child: Container(
        width: double.infinity,  // Ensure the container takes the full width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('dd/MM/yyyy - HH:mm').format(widget.todo.dateTime),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              widget.todo.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}