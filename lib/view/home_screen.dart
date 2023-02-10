import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gettodoapp/controller/google_sign_in_user.dart';
import 'package:gettodoapp/controller/todo_controller.dart';
import 'package:gettodoapp/view/login_screen.dart';
import 'package:gettodoapp/view/todo_view.dart';

import '../model/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoController todoController = Get.put(TodoController());

  @override
  void initState() {
    super.initState();
    todoController.setupTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Todo App"),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                GoogleSignInUser.signOut();
                Get.snackbar("Sign Out", "Sign out successfully", snackPosition: SnackPosition.BOTTOM);

                Get.offAll(() => LoginScreen());
              },
              child: const Icon(Icons.logout))
        ],
      ),
      body: Obx(() => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: todoController.todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple.shade400,
                ),
                child: InkWell(
                  onTap: () async {
                    Todo todo = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => TodoView(
                                  todo: todoController.todos[index],
                                )));
                    // setState(() {
                    //   todos[index] = todo;
                    // });
                    todoController.todos[index] = todo;
                    // todoController.saveTodo();
                  },
                  child: todoController.makeListTile(todoController.todos[index], index),
                ),
              ),
            );
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todoController.addTodo();
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
