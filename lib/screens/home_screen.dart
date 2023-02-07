import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gettodoapp/screens/todo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;
  List todos = [];

    setupTodo() async {
    prefs = await SharedPreferences.getInstance();
    String? stringTodo = prefs.getString('todo');
    List todoList = jsonDecode(stringTodo!);
    for (var todo in todoList) {
      setState(() {
        todos.add(Todo().fromJson(todo));
      });
    }
  }

  void saveTodo() {
    List items = todos.map((e) => e.toJson()).toList();
    prefs.setString('todo', jsonEncode(items));
  }

  @override
  void initState() {
    super.initState();
    setupTodo();

  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Get Todo App"),
        centerTitle: true,
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            elevation: 8.0,
            margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            child: Container(
              decoration:const BoxDecoration(
                color: Color.fromARGB(255, 225, 220, 220),
              ),
              child: InkWell(
                onTap: () async {
                  Todo todo = await Navigator.push(context,
                  MaterialPageRoute(builder: (builder)=>
                  TodoView(todo: todos[index],)));
                        setState(() {
                          todos[index] = todo;
                        });
                        saveTodo();
                      
                },
                child:makeListTile(todos[index], index) ,
              ),
            ),
          );
        }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodo();
        },
        backgroundColor: Colors.purple,
        child:const Icon(Icons.add),
      ),
    );
  }

  addTodo() async {
    int id = Random().nextInt(30);
    Todo t = Todo(id: id, title: '', description: '', status: false);
    Todo returnTodo = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoView(todo: t)));
      setState(() {
        todos.add(returnTodo);
      });
      saveTodo();
    
  }

   makeListTile(Todo todo, index) {
    return ListTile(
        contentPadding:const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding:const EdgeInsets.only(right: 12.0),
          decoration:const  BoxDecoration(
              border:  Border(
                  right:  BorderSide(width: 1.0, color: Colors.white24))),
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: Text("${index + 1}"),
          ),
        ),
        title: Row(
          children: [
            Text(
              todo.title!,
              style:
                const  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 10,
            ),
            todo.status!
                ? const Icon(
                    Icons.verified,
                    color: Colors.greenAccent,
                  )
                : Container()
          ],
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Wrap(
          children: <Widget>[
            Text(todo.description!,
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: const TextStyle(color: Colors.white))
          ],
        ),
        trailing: InkWell(
            onTap: () {
              delete(todo);
            },
            child: const Icon(Icons.delete, color: Colors.white, size: 30.0)));
  }
    delete(Todo todo) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Alert"),
              content:const Text("Are you sure to delete"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child:const Text("No")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        todos.remove(todo);
                      });
                      Navigator.pop(ctx);
                      saveTodo();
                    },
                    child:const Text("Yes"))
              ],
            ));
  }
}


