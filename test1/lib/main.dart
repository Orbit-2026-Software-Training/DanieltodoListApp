import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


List<Map<String, List<dynamic>>> tasksAndDates = [];
List<Task> todoList = [];
List<Task> todoListLow = [];
List<Task> todoListMedium = [];
List<Task> todoListHigh = [];
List<Task> todoListRobotics = [];
List<Task> todoListSchool = [];
List<Task> todoListHome = [];
List<Task> todoListToDisplayLow = todoListLow;
List<Task> todoListToDisplayMedium = todoListMedium;
List<Task> todoListToDisplayHigh = todoListHigh;

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
  Task({required this.name, required this.prAndDate, required this.pColor, required this.dateIsAfter, required this.cat, required this.deco});
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
        if(tempereryP == Priorety.low) {
          pToBeReturnd = 'low';
          todoListLow.add(Task(name: result, prAndDate: PrAndDate(pr: pToBeReturnd, dueDate: dueDateS), pColor: tColor, dateIsAfter: dateIsAfterT, cat: catToBeReturnd, deco: TextDecoration.none));
        } else if(tempereryP == Priorety.medium) {
          pToBeReturnd = "medium";
          todoListMedium.add(Task(name: result, prAndDate: PrAndDate(pr: pToBeReturnd, dueDate: dueDateS), pColor: tColor, dateIsAfter: dateIsAfterT, cat: catToBeReturnd, deco: TextDecoration.none));
        } else {
          pToBeReturnd = "high";
          todoListHigh.add(Task(name: result, prAndDate: PrAndDate(pr: pToBeReturnd, dueDate: dueDateS), pColor: tColor, dateIsAfter: dateIsAfterT, cat: catToBeReturnd, deco: TextDecoration.none));
        }
        if(selectedCategory == Category.robotics) {
          todoListRobotics.add(Task(name: result, prAndDate: PrAndDate(pr: pToBeReturnd, dueDate: dueDateS), pColor: tColor, dateIsAfter: dateIsAfterT, cat: catToBeReturnd, deco: TextDecoration.none));
        } else if(selectedCategory == Category.school) {
          todoListSchool.add(Task(name: result, prAndDate: PrAndDate(pr: pToBeReturnd, dueDate: dueDateS), pColor: tColor, dateIsAfter: dateIsAfterT, cat: catToBeReturnd, deco: TextDecoration.none));
        } else {
          todoListHome.add(Task(name: result, prAndDate: PrAndDate(pr: pToBeReturnd, dueDate: dueDateS), pColor: tColor, dateIsAfter: dateIsAfterT, cat: catToBeReturnd, deco: TextDecoration.none));
        }
        todoList.add(Task(name: result, prAndDate: PrAndDate(pr: pToBeReturnd, dueDate: dueDateS), pColor: tColor, dateIsAfter: dateIsAfterT, cat: catToBeReturnd, deco: TextDecoration.none));
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
                          todoListToDisplayLow = todoListLow;
                          todoListToDisplayMedium = todoListMedium;
                          todoListToDisplayHigh = todoListHigh;
                        } else if(value == 'robotics') {
                          todoListToDisplayHigh = [];
                          todoListToDisplayMedium = [];
                          todoListToDisplayLow = [];
                          for(int i = 0; i < todoListRobotics.length; i++) {
                            String? p = todoListRobotics[i].prAndDate.pr;
                            if(p == 'low') {
                              todoListToDisplayLow.add(todoListRobotics[i]);
                            } else if(p == 'medium') {
                              todoListToDisplayMedium.add(todoListRobotics[i]);
                            } else {
                              todoListToDisplayHigh.add(todoListRobotics[i]);
                            }
                          }
                        } else if(value == 'school') {
                          todoListToDisplayHigh = [];
                          todoListToDisplayMedium = [];
                          todoListToDisplayLow = [];
                          for(int i = 0; i < todoListSchool.length; i++) {
                            String? p = todoListSchool[i].prAndDate.pr;
                            if(p == 'low') {
                              todoListToDisplayLow.add(todoListSchool[i]);
                            } else if(p == 'medium') {
                              todoListToDisplayMedium.add(todoListSchool[i]);
                            } else {
                              todoListToDisplayHigh.add(todoListSchool[i]);
                            }
                          }
                        } else {
                          todoListToDisplayHigh = [];
                          todoListToDisplayMedium = [];
                          todoListToDisplayLow = [];
                          for(int i = 0; i < todoListHome.length; i++) {
                            String? p = todoListHome[i].prAndDate.pr;
                            if(p == 'low') {
                              todoListToDisplayLow.add(todoListHome[i]);
                            } else if(p == 'medium') {
                              todoListToDisplayMedium.add(todoListHome[i]);
                            } else {
                              todoListToDisplayHigh.add(todoListHome[i]);
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
                  todoListToDisplayLow.map((Task task) {
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
                            todoListToDisplayLow.remove(task);
                            todoListLow.removeWhere((task) => task.name == task.name);
                            todoList.removeWhere((task) => task.name == task.name);
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
              Expanded(
                child: ListView(
                  children: 
                  todoListToDisplayMedium.map((Task task) {
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
                            todoListToDisplayMedium.remove(task);
                            todoListMedium.removeWhere((task) => task.name == task.name);
                            todoList.removeWhere((task) => task.name == task.name);
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
              Expanded(
                child: ListView(
                  children: 
                  todoListToDisplayHigh.map((Task task) {
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
                            todoListToDisplayHigh.remove(task);
                            todoListHigh.removeWhere((task) => task.name == task.name);
                            todoList.removeWhere((task) => task.name == task.name);
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
                      todoListLow.removeWhere((item) => item.name == selectedTask.name);
                      todoListMedium.removeWhere((item) => item.name == selectedTask.name);
                      todoListHigh.removeWhere((item) => item.name == selectedTask.name);
                      todoListRobotics.removeWhere((item) => item.name == selectedTask.name);
                      todoListSchool.removeWhere((item) => item.name == selectedTask.name);
                      todoListHome.removeWhere((item) => item.name == selectedTask.name);
                      todoListToDisplayLow.removeWhere((item) => item.name == selectedTask.name);
                      todoListToDisplayMedium.removeWhere((item) => item.name == selectedTask.name);
                      todoListToDisplayHigh.removeWhere((item) => item.name == selectedTask.name);
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
