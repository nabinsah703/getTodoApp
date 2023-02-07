import 'package:flutter/material.dart';

import '../model/todo.dart';

class TodoView extends StatefulWidget {
  Todo? todo;
  TodoView({Key? key, this.todo}) : super(key: key);

  @override
  _TodoViewState createState() => _TodoViewState(todo: todo!);
}

class _TodoViewState extends State<TodoView> {
  Todo todo;
  _TodoViewState({required this.todo});
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
      titleController.text = todo.title!;
      descriptionController.text = todo.description!;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.purple,
        title: const Text("Add Todo"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                onChanged: (data) {
              todo.title = data;
                },
                decoration:  InputDecoration(
              labelText: "Title",
              border:  OutlineInputBorder(
                borderRadius:  BorderRadius.circular(25.0),
              ),
                ),
                controller: titleController,
              ),
             const SizedBox(
                height: 25,
              ),
              TextField(
                maxLines: 5,
                onChanged: (data) {
              todo.description = data;
                },
                decoration:  InputDecoration(
              labelText: "Description",
              border:  OutlineInputBorder(
                borderRadius:  BorderRadius.circular(25.0),
              ),
                ),
                controller: descriptionController,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 55.0,
        child: BottomAppBar(
          color: Colors.purple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text("Alert"),
                              content: Text(
                                  "Mark this todo as ${todo.status! ? 'not done' : 'done'}  "),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child:const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      todo.status = !todo.status!;
                                    });
                                    Navigator.of(ctx).pop();
                                  },
                                  child:const Text("Yes"),
                                )
                              ],
                            ));
                  },
                  child: Text(
                    "${todo.status! ? 'Mark as Not Done' : 'Mark as Done'} ",
                    style: const TextStyle(color: Colors.white),
                  )),
              const VerticalDivider(
                color: Colors.white,
              ),
              IconButton(
                icon:const Icon(Icons.save, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context, todo);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
