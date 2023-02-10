import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gettodoapp/controller/auth_controller.dart';
import 'package:gettodoapp/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/todo_view.dart';

class TodoController extends GetxController {
  late SharedPreferences prefs;
  // RxList todos = [].obs;
  RxList<Todo> _todos = <Todo>[].obs;
  RxList<Todo> get todos => _todos;
// set setTodos(List<Todo> todo )=> _todos.value = todo;
  // List todos = [].obs;

  void clear() {
    _todos.value = <Todo>[];
  }

  AuthController authController = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();
    if (authController.user == null) {
      _todos.value = <Todo>[];
    }
  }

  setupTodo() async {
    prefs = await SharedPreferences.getInstance();
    String? stringTodo = prefs.getString('todo');
    List todoList = jsonDecode(stringTodo!);
    for (var todo in todoList) {
      // todos.add(Todo().fromJson(todo));
      _todos.add(Todo().fromJson(todo));
      // setState(() {
      //   todos.add(Todo().fromJson(todo));
      // });
    }
  }

  void saveTodo() {
    List items = _todos.map((e) => e.toJson()).toList();
    prefs.setString('todo', jsonEncode(items));
  }

  addTodo() async {
    int id = Random().nextInt(30);
    Todo todo = Todo(id: id, title: '', description: '', status: false);
    Todo returnTodo = await Get.to(() => TodoView(todo: todo));

    // setState(() {
    //   todos.add(returnTodo);
    // });
    _todos.add(returnTodo);
    
    saveTodo();
    update();
  }

  delete(Todo todo) {
    return Get.defaultDialog(
      title: "Alert",
      content: const Text("Are you sure to delete"),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();

              // Navigator.pop(ctx);
            },
            child: const Text(
              "No",
            )),
        TextButton(
            onPressed: () {
              // setState(() {
              //   todos.remove(todo);
              // });
              _todos.remove(todo);
              update();
              saveTodo();
              Get.back();
            },
            child: const Text(
              "Yes",
            ))
      ],
    );
  }

  makeListTile(Todo todo, index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration: const BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.white24))),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text("${index + 1}"),
        ),
      ),
      title: Row(
        children: [
          Text(
            todo.title!,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      subtitle: Text(todo.description!, style: const TextStyle(color: Colors.white)),
      trailing: InkWell(
        onTap: () {
          delete(todo);
        },
        child: const Icon(Icons.delete, color: Colors.white, size: 30.0),
      ),
    );
  }
}
