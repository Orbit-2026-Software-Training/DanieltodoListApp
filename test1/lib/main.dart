import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

List<Task> todoList = [];
List<Task> todoListToDisplay = todoList;

final List<Task> selected = [];
final TextEditingController dialogController = TextEditingController();
final formKey = GlobalKey<FormState>();
String isListEmpty = '';
DateTime focusedDay = DateTime.now();
DateTime selectedDay = DateTime.now();
DateTime dateToAdd = DateTime.now();
late Color tColor;
String dateIsAfterT = '';
enum Priority {
  low('low', Colors.green),
  medium('medium', Colors.yellow),
  high('high', Colors.red);

  final String titleP;
  final Color cP;

  const Priority(this.titleP, this.cP);
}

enum Category {
  school,
  robotics,
  home,
}

enum CategoryP {
  school,
  robotics,
  home,
  all,
}

List<String> catP = ['school', 'robotics', 'home', 'all'];
List<String> catt = ['school', 'robotics', 'home'];
List<String> pList = ['low', 'medium', 'high'];
String dueDateS = 'n';

Priority? selectedPriority = Priority.low;
Priority? temporaryP = Priority.low;
Category selectedCategory = Category.robotics;
Category? temporaryC = Category.robotics;
CategoryP selectedCategoryP = CategoryP.robotics;
CategoryP? tempereryCP = CategoryP.all;

String returndCat = 'robotics';
String returndP = '';

class PrAndDate {
  String dueDate;
  Priority? pr;
  PrAndDate({required this.pr, required this.dueDate});
}

class Task {
  TextDecoration deco;
  String cat;
  String dateIsAfter;
  String name;
  PrAndDate prAndDate;
  int i;
  Task({required this.name, required this.prAndDate, required this.dateIsAfter, required this.cat, required this.deco, required this.i});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To do list app',
      home: CalcApp(),
    );
  }
}

class CalcApp extends StatefulWidget {
  const CalcApp({super.key});

  @override
  State<CalcApp> createState() => _CalcAppState();
}

class _CalcAppState extends State<CalcApp> {

  Future<void> showInputDialog(BuildContext context) async {

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( 
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Add New Item'),
              content: SingleChildScrollView(
                child: 
                  SizedBox(
                    width: 450,
                child: 
                  Column(
                    children: [
                      Form(
                        key: formKey,
                        child: TextFormField(
                          controller: dialogController,
                          autofocus: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "task name can't be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      TableCalendar(
                    firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    lastDay: DateTime.utc(2035, 12, 31),
                    focusedDay: focusedDay,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDay, day);
                    },
                    onDaySelected: (newSelectedDay, currentFocusedDay) {
                      setDialogState(() {
                        selectedDay = newSelectedDay;
                        dateToAdd = newSelectedDay;
                        focusedDay = currentFocusedDay;
                      });
                    },
                  ),
                  DropdownMenu<String>(
                    initialSelection: 'low',
                    label: const Text('Select Category'),
                    onSelected: (String? value) {
                      setDialogState(() {
                        switch (value) {
                          case 'low':
                            selectedPriority = Priority.low;
                            temporaryP = Priority.low;
                            break;
                          case 'medium':
                            selectedPriority = Priority.medium;
                            temporaryP = Priority.medium;
                            break;
                          case 'high':
                            selectedPriority = Priority.high;
                            temporaryP = Priority.high;
                            break;
                        }
                      });
                    },
                    dropdownMenuEntries: pList.map<DropdownMenuEntry<String>>((String p) {
                      return DropdownMenuEntry<String>( 
                        value: p,
                        label: p,
                      );
                    }).toList(),
                  ),
                  DropdownMenu<String>(
                    initialSelection: 'robotics',
                    label: const Text('Select category'),
                    onSelected: (String? value) {
                      setDialogState(() {
                        switch (value) {
                          case 'robotics':
                            temporaryC = Category.robotics;
                            returndCat = 'robotics';
                            selectedCategory = Category.robotics;
                            break;
                          case 'home':
                            temporaryC = Category.home;
                            returndCat = 'home';
                            selectedCategory = Category.home;
                            break;
                          case 'school':
                            temporaryC = Category.school;
                            returndCat = 'school';
                            selectedCategory = Category.school;
                            break;
                        }
                      });
                    },
                    dropdownMenuEntries: catt.map<DropdownMenuEntry<String>>((String p) {
                      return DropdownMenuEntry<String>( 
                        value: p,
                        label: p,
                      );
                    }).toList(),
                  ),
                  ]
                )
              ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, dialogController.text);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        dueDateS = "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
        switch(temporaryP) {
          case Priority.low:
            tColor = Colors.green;
            break;
          case Priority.medium:
            tColor = Colors.yellow;
            break;
          case Priority.high:
            tColor = Colors.red;
            break;
          case null:
            break;
        }
        if(!(dateToAdd.isAfter(DateTime.now().add(const Duration(days: -1))))) {
          dateIsAfterT = "due date past!";
        }
        isListEmpty = '';
        int iT = 0; 
        switch(temporaryP) {
          case null:
            break;
          case Priority.low:
            returndP = 'low';
            iT = 3;
            break;
          case Priority.medium:
            iT = 2;
            returndP = "medium";
            break;
          case Priority.high:
            iT = 1;
            returndP = "high";
            break;
        }
        todoList.add(Task(name: result, prAndDate: PrAndDate(pr: temporaryP, dueDate: dueDateS), dateIsAfter: dateIsAfterT, cat: returndCat, deco: TextDecoration.none, i: iT));
        todoList.sort((a, b) => b.i.compareTo(a.i));
        temporaryP = Priority.low;
      });
      dialogController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(todoList.isEmpty) {
      isListEmpty = "no tasks yet";
    }
    return Scaffold(
      appBar: AppBar(title: const Text('To Do List')),
      body: Center(
        child: SizedBox(
          height: 400,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isListEmpty),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownMenu<String>(
                    initialSelection: 'all',
                    label: const Text('Select category'),
                    onSelected: (String? value) {
                        switch (value) {
                          case 'all':
                            todoListToDisplay = todoList;
                            break;
                          case 'robotics':
                          todoListToDisplay = [];
                          for(int i = 0; i < todoList.length; i++) {
                            if(todoList[i].cat == 'robotics') {
                              todoListToDisplay.add(todoList[i]);
                            }
                          }
                          break;
                        case 'school':
                          todoListToDisplay = [];
                          for(int i = 0; i < todoList.length; i++) {
                            if(todoList[i].cat == 'school') {
                              todoListToDisplay.add(todoList[i]);
                            }
                          }
                          break;
                        case 'home':
                          todoListToDisplay = [];
                          for(int i = 0; i < todoList.length; i++) {
                            if(todoList[i].cat == 'home') {
                              todoListToDisplay.add(todoList[i]);
                            }
                          }
                          break;
                        }
                      setState((){});
                    },
                    dropdownMenuEntries: catP.map<DropdownMenuEntry<String>>((String p) {
                      return DropdownMenuEntry<String>( 
                        value: p,
                        label: p,
                      );
                    }).toList(),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: 
                  todoListToDisplay.map((Task task) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: task.prAndDate.pr?.cP ?? Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: selected.contains(task),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selected.add(task);
                                task.deco = TextDecoration.lineThrough;
                              } else {
                                selected.remove(task);
                                task.deco = TextDecoration.none;
                              }
                            });
                          },
                        ),
                        title: Text(
                          '${task.name}    ${task.prAndDate.dueDate}    ${task.prAndDate.pr?.titleP ?? 'None'}    ${task.dateIsAfter}    ${task.cat}',
                          style: TextStyle(
                            decoration: task.deco,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              todoList.removeWhere((taask) => taask.name == task.name);
                              todoListToDisplay.removeWhere((ttask) => ttask.name == task.name);
                            });
                            if (todoList.isEmpty) {
                              setState(() {
                                isListEmpty = "no tasks yet";
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    for (var selectedTask in selected) {
                      todoList.removeWhere((item) => item.name == selectedTask.name);
                      todoListToDisplay.removeWhere((item) => item.name == selectedTask.name);
                    }
                    selected.clear();
                  });
                },
                child: const Text('remove completed'),
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showInputDialog(context);
                    },
                    child: const Text('+'),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text('${selected.length} out of ${todoList.length} completed')
            ],
            ),
          ),
        ),
    );
  }
}
