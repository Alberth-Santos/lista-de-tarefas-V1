import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../repositories/task _repository.dart';
import '../widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskRepository taskRepository = TaskRepository();

  List<Task> tasks = [];
  String? errorText;

  final taskController = TextEditingController();
  @override
  void initState() {
    super.initState();
    taskRepository.getTaskList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Lista de Tarefas",
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: taskController,
                        decoration: InputDecoration(
                          errorText: errorText,
                          hintText: "Adicione uma tarefa",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        String text = taskController.text;
                        if (text.isEmpty) {
                          setState(() {
                            errorText = "Digite algo!!!!";
                          });
                          return;
                        }

                        setState(() {
                          Task newTask = Task(
                            title: text,
                          );
                          tasks.add(newTask);
                          errorText = null;
                        });
                        taskController.clear();
                        taskRepository.saveTaskList(tasks);
                      },
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks)
                        TaskListItem(
                          task: task,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          Text("Você possui ${tasks.length} tarefas pendentes"),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: deletealltasks,
                      child: const Text("Limpar tudo"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Task task) {
    setState(() {
      tasks.remove(task);
    });
    taskRepository.saveTaskList(tasks);
  }

  void deletealltasks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Apagar tudo?",
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("não")),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAll();
            },
            child: const Text("sim"),
          ),
        ],
      ),
    );
  }

  void deleteAll() {
    setState(() {
      tasks.clear();
    });
    taskRepository.saveTaskList(tasks);
  }
}
