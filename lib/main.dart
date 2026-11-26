import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class TaskData {
  String name;
  String description;

  TaskData({
    required this.name,
    required this.description,
  });
}

class Task extends StatelessWidget {
  final TaskData data;
  final void Function()? onPressed;
  final void Function()? onPressComplete;
  final bool isExpanded;

  const Task({
    super.key,
    required this.data,
    this.onPressed,
    this.onPressComplete,
    this.isExpanded = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: BoxBorder.all(
          color: Color.fromARGB(0xFF, 0x5, 0x5, 0x5)
        )
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          spacing: 8.0,
          children: [
            Text(
              data.name,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isExpanded)
              Column(
                spacing: 8.0,
                children: [
                  Divider(color: Colors.black),
                  if (data.description.isNotEmpty)
                    Text(
                      data.description,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: onPressComplete,
                    child: Text("Completo")
                  )
                ],
              )
          ],
        )
      )
    );
  }
}

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  late List<TaskData> _tasks;
  late TextEditingController _nameTextFieldController;
  late TextEditingController _descriptionTextFieldController;
  int _currentTaskSelected = -1;
  bool _showHelp = false;

  @override
  void initState() {
    super.initState();
    _tasks = [];
    _nameTextFieldController = TextEditingController();
    _descriptionTextFieldController = TextEditingController();
  }
  
  void _addTask() {
    if (_nameTextFieldController.text.trim().isEmpty) {
      setState(() {
        _showHelp = true;
      });
      return;
    }

    setState(() {
      _tasks.add(TaskData(
        name: _nameTextFieldController.text,
        description: _descriptionTextFieldController.text
      ));

      _nameTextFieldController.text = "";
      _descriptionTextFieldController.text = "";
      _showHelp = false;
      _currentTaskSelected = -1;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Tarefa adicionada!")
    ));
  }

  void _onPressCompleteTask(int index) {
    _tasks.removeAt(index);
    setState(() {
      _currentTaskSelected = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: BoxBorder.all(
          color: Color.fromARGB(0xFF, 0x5, 0x5, 0x5)
        )
      ),
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.0,
        children: [
          TextField(
            controller: _nameTextFieldController,
            decoration: InputDecoration(
              label: Text("Titulo"),
              error: _showHelp ? Text("Campo obrigatorio") : null
            ),
          ),
          TextField(
            controller: _descriptionTextFieldController,
            decoration: InputDecoration(
              label: Text("Descrição"),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _addTask,
                  child: Text("Adicionar tarefa"),
                )
              )
            ],
          ),
          for (int index = 0; index < _tasks.length; ++index)
            Row(
              children: [
                Expanded(
                  child: Task(
                    data: _tasks[index],
                    isExpanded: _currentTaskSelected == index,
                    onPressed: () => setState(() {
                      if (_currentTaskSelected == index) {
                        _currentTaskSelected = -1;
                      } else {
                        _currentTaskSelected = index;
                      }
                    }),
                    onPressComplete: () => _onPressCompleteTask(index)
                  )
                )
              ],
            )
        ]
      )
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TODO",
      home: Scaffold(
        body: TaskManager()
      )
    );
  }
}
