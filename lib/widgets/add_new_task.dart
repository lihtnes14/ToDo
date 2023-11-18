import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/task.dart';

class AddNewTask extends StatefulWidget {
  final String id;
  final bool isEditMode;

  AddNewTask({
    required this.id,
    required this.isEditMode,
  });

  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  Task? task;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  String? _inputDescription;
  final _formKey = GlobalKey<FormState>();

  void _pickUserDueDate() {
    showDatePicker(
      context: context,
      initialDate: widget.isEditMode ? _selectedDate! : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        _selectedDate = date;
      });
    });
  }

  void _pickUserDueTime() {
    showTimePicker(
      context: context,
      initialTime: widget.isEditMode ? _selectedTime! : TimeOfDay.now(),
    ).then((time) {
      if (time == null) {
        return;
      }
      setState(() {
        _selectedTime = time;
      });
    });
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_selectedDate == null && _selectedTime != null) {
        _selectedDate = DateTime.now();
      }
      if (!widget.isEditMode) {
        Provider.of<TaskProvider>(context, listen: false).createNewTask(
          Task(
            id: DateTime.now().toString(),
            description: _inputDescription!,
            dueDate: _selectedDate!,
            dueTime: _selectedTime!,
          ),
        );
      } else {
        Provider.of<TaskProvider>(context, listen: false).editTask(
          Task(
            id: task!.id,
            description: _inputDescription!,
            dueDate: _selectedDate!,
            dueTime: _selectedTime!,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    if (widget.isEditMode) {
      task =
          Provider.of<TaskProvider>(context, listen: false).getById(widget.id);
      _selectedDate = task!.dueDate;
      _selectedTime = task!.dueTime;
      _inputDescription = task!.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Title', style: Theme.of(context).textTheme.subtitle1),
                TextFormField(
                  initialValue:
                      _inputDescription == null ? null : _inputDescription,
                  decoration: InputDecoration(
                    hintText: 'Describe your task',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _inputDescription = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Due date',
                    style: Theme.of(context).textTheme.subtitle1),
                TextFormField(
                  onTap: () {
                    _pickUserDueDate();
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: _selectedDate == null
                        ? 'Provide your due date'
                        : DateFormat.yMMMd()
                            .format(_selectedDate!)
                            .toString(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Due time',
                    style: Theme.of(context).textTheme.subtitle1),
                TextFormField(
                  onTap: () {
                    _pickUserDueTime();
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: _selectedTime == null
                        ? 'Provide your due time'
                        : _selectedTime!.format(context),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _validateForm();
                    },
                    child: Text(!widget.isEditMode ? 'ADD TASK' : 'EDIT TASK'),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  // Add your logic for the button press here
                },
                child: Icon(Icons.add), // Change the icon as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
