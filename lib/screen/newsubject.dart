import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/models/todo.dart';

class Newsub extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<Newsub> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TodoProvider _db;

  _AddTodoState() {
    _db = TodoProvider();
  }

  @override
  void initState() {
    super.initState();
    _db.open().then((result) {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController subjectController = TextEditingController();

    TextFormField todoTextField = TextFormField(
      controller: subjectController,
      decoration: InputDecoration(
        hintText: "Subject",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please fill subject';
        }
      },
    );

    RaisedButton submitButton = RaisedButton(
      child: const Text('Save'),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          Todo todo = Todo(subject: subjectController.text);
          _db.insert(todo).then((r) {
            Navigator.pushReplacementNamed(context, '/');
          });
        }
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Subject'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: ListView(
            children: <Widget>[
              todoTextField,
              submitButton,
            ],
          ),
        ),
      ),
    );

  }

  
}
