import 'package:flutter/material.dart';
import './add_screen.dart';
import 'package:flutter_assignment_02/models/todo.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoScreenState();
  }
}

class TodoScreenState extends State {
  bool test = false;
  int _current_state = 0;
  int countTodo = 0;
  int countDone = 0;
  List<Todo> todolist;
  List<Todo> todoDoneList;
  
  TodoProvider db = TodoProvider();
  @override

  void getTodoList() async{
    await db.open("todo.db");
    db.getAllTodos().then((todolist) {
      setState(() {
        this.todolist = todolist;
        this.countTodo = todolist.length;
      });
    });
    db.getAllDoneTodos().then((todoDoneList) {
      setState(() {
       this.todoDoneList = todoDoneList;
       this.countDone = todoDoneList.length; 
      });
    });
  }
  

  Widget build(BuildContext context) {
    List current_tab = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TodoAdd()));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          db.deleteAllDoneTodo();
        },
      )
    ];

    List current_screen = [
      countTodo == 0 ? Text ("No data found.."):
      ListView.builder(
        itemCount: countTodo,
        itemBuilder: (context,int position){
          return Column(
              children: <Widget>[
                Divider(
                  height: 5.0,
                ),
                ListTile(
                  title: Text(this.todolist[position].title,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  trailing: Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        todolist[position].done = value;
                      });
                      db.update(todolist[position]);
                    },
                    value: todolist[position].done
                  ),
                )
              ],
            );
        },
      ),
      countDone == 0 ? Text ("No data found.."):
      ListView.builder(
        itemCount: countDone,
        itemBuilder: (context,int position){
          return Column(
              children: <Widget>[
                Divider(
                  height: 5.0,
                ),
                ListTile(
                  title: Text(this.todoDoneList[position].title,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  trailing: Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        todoDoneList[position].done = value;
                      });
                      db.update(todoDoneList[position]);
                    },
                    value: todoDoneList[position].done
                  ),
                )
              ],
            );
        },
      ),
    ];
    getTodoList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            _current_state == 0 ? current_tab[0] : current_tab[1]
          ],
          backgroundColor: Colors.blue,
        ),
        body: Center(child: _current_state == 0 ? current_screen[0] : current_screen[1]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current_state,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Task')),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text('Complete'))
          ],
          onTap: (int index) {
            setState(() {
              _current_state = index;
            });
          },
        ),
      ),
    );
  }
}
