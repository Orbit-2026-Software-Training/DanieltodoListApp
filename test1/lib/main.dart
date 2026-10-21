import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'sort_by_priority.dart';

Sortbypriority S = Sortbypriority();

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
enum Priorety {
  low,
  medium,
  high,
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

Priorety? selectedPriority = Priorety.low;
Priorety? tempereryP = Priorety.low;
Category selectedCategory = Category.robotics;
Category? tempereryC = Category.robotics;
CategoryP selectedCategoryP = CategoryP.robotics;
CategoryP? tempereryCP = CategoryP.all;

String catToBeReturnd = 'robotics';
String pToBeReturnd = '';

class PrAndDate {
  String dueDate;
  String? pr;
  PrAndDate({required this.pr, required this.dueDate});
}

class Task {
  TextDecoration deco;
  String cat;
  String dateIsAfter;
  Color pColor;
  String name;
  PrAndDate prAndDate;
  int i;
  Task({required this.name, required this.prAndDate, required this.pColor, required this.dateIsAfter, required this.cat, required this.deco, required this.i});
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
                    firstDay: DateTime.now(),
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
                        if(value == 'low') {
                          selectedPriority = Priorety.low;
                          tempereryP = Priorety.low;
                        } else if(value == 'medium') {
                          selectedPriority = Priorety.medium;
                          tempereryP = Priorety.medium;
                        } else {
                          selectedPriority = Priorety.high;
                          tempereryP = Priorety.high;
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
                        if(value == 'robotics') {
                          tempereryC = Category.robotics;
                          catToBeReturnd = 'robotics';
                          selectedCategory = Category.robotics;
                        } else if(value == 'home') {
                          tempereryC = Category.home;
                          catToBeReturnd = 'home';
                          selectedCategory = Category.home;
                        } else {
                          tempereryC = Category.school;
                          catToBeReturnd = 'school';
                          selectedCategory = Category.school;
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
        if(tempereryP == Priorety.low) {
          tColor = Colors.green;
        } else if(tempereryP == Priorety.medium) {
          tColor = Colors.yellow;
        } else {
          tColor = Colors.red;
        }
        if(!(dateToAdd.isAfter(DateTime.now().add(const Duration(days: -1))))) {
          dateIsAfterT = "due date past!";
        }
        isListEmpty = '';
        int iT = 0; 
        if(tempereryP == Priorety.low) {
          pToBeReturnd = 'low';
          iT = 3;
        } else if(tempereryP == Priorety.medium) {
          iT = 2;
          pToBeReturnd = "medium";
        } else {
          iT = 1;
          pToBeReturnd = "high";
        }
        todoList.add(Task(name: result, prAndDate: PrAndDate(pr: pToBeReturnd, dueDate: dueDateS), pColor: tColor, dateIsAfter: dateIsAfterT, cat: catToBeReturnd, deco: TextDecoration.none, i: iT));
        todoList.sort((a, b) => b.i.compareTo(a.i));
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
                        if(value == 'all') {
                          todoListToDisplay = todoList;
                        } else if(value == 'robotics') {
                          todoListToDisplay = [];
                          for(int i = 0; i < todoList.length; i++) {
                            if(todoList[i].cat == 'robotics') {
                              todoListToDisplay.add(todoList[i]);
                            }
                          }
                        } else if(value == 'school') {
                          todoListToDisplay = [];
                          for(int i = 0; i < todoList.length; i++) {
                            if(todoList[i].cat == 'school') {
                              todoListToDisplay.add(todoList[i]);
                            }
                          }
                        } else {
                          todoListToDisplay = [];
                          for(int i = 0; i < todoList.length; i++) {
                            if(todoList[i].cat == 'home') {
                              todoListToDisplay.add(todoList[i]);
                            }
                          }
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
                    return ListTile(
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
                    tileColor: task.pColor,
                    title: Text(
                      style: TextStyle(
                        decoration: task.deco,
                      ),
                      '${task.name}    ${task.prAndDate.dueDate}    ${task.prAndDate.pr}    ${task.dateIsAfter}    ${task.cat}'
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            todoList.removeWhere((taask) => taask.name == task.name);
                            todoListToDisplay.removeWhere((ttask) => ttask.name == task.name);
                          });
                          if(todoList.isEmpty) {
                            setState(() {
                              isListEmpty = "no tasks yet";
                            });
                          }
                        },
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
