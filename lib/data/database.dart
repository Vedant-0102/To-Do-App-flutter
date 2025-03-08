import 'package:hive/hive.dart';

class ToDoDataBase {
  // List of tasks
  List toDoList = [];

  // Reference to the Hive box
  final _myBox = Hive.box('todo'); // Since box is already opened in main.dart

  // Constructor - immediately load data
  ToDoDataBase() {
    loadData();
  }

  // Load data from Hive
  void loadData() {
    if (_myBox.get('data') == null) {
      createInitialData();
    } else {
      toDoList = List.from(_myBox.get('data'));
    }
  }

  // Run when app opens for the first time
  void createInitialData() {
    toDoList = [
      ['Code Project', false],
      ['test1', false],
      ['test2', false],
    ];
    updateData(); // Save initial data
  }

  // Update Hive database
  void updateData() {
    _myBox.put('data', toDoList);
  }
}
