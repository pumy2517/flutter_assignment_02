import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/models/todo.dart';

class TodoAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoAddState();
  }
}

class TodoAddState extends State<StatefulWidget> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController subjectTodo = TextEditingController();
  TodoProvider db = TodoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: subjectTodo,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value){
                  if(value.isEmpty){
                    return "Please fill subject";
                  }
                },
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () async {
                  _formkey.currentState.validate();
                  if (subjectTodo.text.isNotEmpty) {             
                    await db.open("todo.db");
                    Todo todo = Todo();
                    todo.title = subjectTodo.text;
                    todo.done = false;
                    await db.insert(todo);
                    Navigator.pop(context, true);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
