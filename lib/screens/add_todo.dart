import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Todo"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)),
                      focusColor: Colors.red),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)),
                      focusColor: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      backgroundColor: Colors.purple,
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}