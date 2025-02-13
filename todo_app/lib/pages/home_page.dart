import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box mybox;
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    super.initState();

    // Initialize Hive box before using it
    mybox = Hive.box('todo');

    // Load data and update UI
    if (mybox.get('data') == null || (mybox.get('data') as List).isEmpty) {
      db.createInitialData();
      mybox.put('data', db.toDoList);
    } else {
      db.toDoList = List.from(mybox.get('data'));
    }

    setState(() {}); // Force UI refresh to show stored tasks
  }

  // Text controller
  final controller = TextEditingController();

  // Checkbox clicked function
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = value ?? false;
    });

    db.updateData();
  }

  // Save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([controller.text, false]);
      controller.clear();
      Navigator.of(context).pop();
    });

    db.updateData();
  }

  // New task dialog
  void createNewTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogBox(
          controller: controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // Delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });

    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 159, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 98, 237),
        title: const Text('To Do App'),
        centerTitle: true,
        elevation: 0,
      ),

      // Action button
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),

      body: db.toDoList.isEmpty
          ? const Center(
              child: Text(
                'No tasks available',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return TodoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
    );
  }
}
