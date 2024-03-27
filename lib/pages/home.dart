import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import the createtask.dart file
import 'package:task_new/pages/createtask.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample tasks list (replace with your data fetching logic)
  List<Task> tasks = [
    Task(
        title: "Buy groceries",
        description: "Milk, bread, eggs",
        dueDate: DateTime.now().add(Duration(days: 1)),
        priority: true),
    Task(
        title: "Finish report",
        description: "Marketing report",
        dueDate: DateTime.now().add(Duration(days: 3)),
        priority: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          DropdownButton(
            icon: Icon(Icons.settings),
            items: [
              DropdownMenuItem(
                child: Text('Sort by Priority'),
                value: 'priority',
              ),
              DropdownMenuItem(
                child: Text('Sort by Due Date'),
                value: 'dueDate',
              ),
            ],
            onChanged: (value) {
              // Implement sorting logic based on selected value
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(task: tasks[index]);
        },
      ),
       
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Handle potential errors during task creation
          try {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTask(onTaskCreated: _addTask),
              ),
            );
          } catch (error) {
            // Display an error message or handle the error appropriately
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred while creating the task.'),
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }
}

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final bool priority;

  Task(
      {required this.title,
      required this.description,
      required this.dueDate,
      required this.priority});
}

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: task.priority ? Colors.lightGreenAccent : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Text(task.description),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDate(task.dueDate)),
              Icon(
                task.priority ? Icons.star : Icons.star_outline,
                color: task.priority ? Colors.amber : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}

