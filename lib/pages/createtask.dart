import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_new/pages/home.dart';

class CreateTask extends StatefulWidget {
  final Function(Task) onTaskCreated; // Callback to add task to the list

  const CreateTask({required this.onTaskCreated, Key? key}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  bool _isPriority = false;
  DateTime _dueDate = DateTime.now().add(Duration(days: 1));

  final _dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              CheckboxListTile(
                title: Text('Priority'),
                value: _isPriority,
                onChanged: (value) => setState(() => _isPriority = value!),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _dateFormatter.format(_dueDate),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newTask = Task(
                      title: _title,
                      description: _description,
                      dueDate: _dueDate,
                      priority: _isPriority,
                    );
                    widget.onTaskCreated(newTask);
                    Navigator.pop(context); // Close the create task page
                  }
                },
                child: Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => _dueDate = pickedDate);
    }
  }
}
