import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productive_u/globel.dart';
import 'package:productive_u/model/task.dart';
import 'package:productive_u/provider/auth_service_provider.dart';
import 'package:productive_u/provider/task_provider.dart';
import 'package:productive_u/view/components/common_drawer.dart';
import 'package:productive_u/view/components/custom_floating_textfield.dart';
import 'package:productive_u/view/components/my_progress_indicator.dart';
import 'package:productive_u/view/components/task_tile.dart';
import 'package:productive_u/view/components/time_filter.dart';
import 'package:productive_u/view/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = AuthServiceProvider().currentUser;

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final noteController = TextEditingController();

  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now().add(Duration(hours: 1));

  String _priority = 'No Priority';
  String _status = 'Todo';
  bool _isOneDayTask = false;
  bool _isNotify = false;

  String _taskId = "";

  String errorMessage = "";

  final List<String> priorities = [
    'Urgent',
    'High',
    'Medium',
    'Low',
    'No Priority'
  ];
  final List<String> statuses = ['Todo', 'In-Progress', 'Done'];

  void _displayTaskPopUp(
      {required String popupTitle,
      required void Function()? onPressed,
      required bool isCreate}) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              backgroundColor: AppTheme.lighbackground,
              title: Text(
                popupTitle,
                style: AppTheme.subheading2,
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomFloatingTextfield(
                        label: "Title*",
                        controller: titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),
                      // Start Date & Time
                      ListTile(
                        title: Text('Start Date & Time'),
                        subtitle: Text(
                          '${DateFormat.yMd().format(_startDateTime)} '
                          '${DateFormat.jm().format(_startDateTime)}',
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDateTime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(_startDateTime),
                            );
                            if (time != null) {
                              setState(() {
                                _startDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });

                              print(_startDateTime);
                            }
                          }
                        },
                      ),
                      // End Date & Time
                      ListTile(
                        title: Text('End Date & Time'),
                        subtitle: Text(
                          '${DateFormat.yMd().format(_endDateTime)} '
                          '${DateFormat.jm().format(_endDateTime)}',
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDateTime.isAfter(_startDateTime)
                                ? _endDateTime
                                : _startDateTime,
                            firstDate: _startDateTime,
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_endDateTime),
                            );
                            if (time != null) {
                              setState(() {
                                _endDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                              final isSameDay = checkIsSameDay(
                                  startDateTime: _startDateTime,
                                  endDateTime: _endDateTime);
                              print("IS same day? $isSameDay");
                              if (!isSameDay) {
                                setState(() => _isOneDayTask = false);
                              }
                            }
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      // Priority Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        value: _priority,
                        items: priorities.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _priority = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      // Status Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        value: _status,
                        items: statuses.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      // One Day Task Checkbox
                      CheckboxListTile(
                        title: Text('One Day Task'),
                        value: _isOneDayTask,
                        onChanged: (value) {
                          setState(() {
                            _isOneDayTask = value!;

                            if (_isOneDayTask) {
                              _endDateTime = DateTime(
                                _startDateTime.year,
                                _startDateTime.month,
                                _startDateTime.day,
                                23,
                                59,
                              );
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('Notify me'),
                        value: _isNotify,
                        onChanged: (value) {
                          setState(() {
                            _isNotify = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      // Notes
                      CustomFloatingTextfield(
                        label: "Notes",
                        controller: noteController,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                //Cancel button
                TextButton(
                  onPressed: () {
                    cleanForm();
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),

                //Save button
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text(isCreate ? "Create Task" : "Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Task Create + Update
  void saveTaskFunction(String operation) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //Create a Task object for the task
      final taskObj = Task(
        taskId: _taskId,
        name: titleController.text,
        note: noteController.text,
        startDate: _startDateTime,
        endDate: _endDateTime,
        status: _status,
        priority: _priority,
        isNotify: _isNotify,
      );

      Provider.of<TaskProvider>(context, listen: false)
          .scheduleNotificaiton(taskObj);

      //Call create task method from "TaskProvider"
      try {
        if (operation == 'create') {
          await Provider.of<TaskProvider>(context, listen: false)
              .createTask(taskObj.toMap());
        } else {
          await Provider.of<TaskProvider>(context, listen: false)
              .updateTask(taskObj.toMap());
        }
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
          print(errorMessage);
        });
      }

      if (errorMessage != "") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Done!"),
          backgroundColor: Colors.green,
        ));
      }
      cleanForm();
      Navigator.pop(context);
    }
  }

  //Set all the value to default
  void cleanForm() {
    setState(() {
      titleController.clear();
      noteController.clear();
      _startDateTime = DateTime.now();
      _endDateTime = DateTime.now().add(Duration(hours: 1));
      _priority = 'No Priority';
      _status = 'Todo';
      _isOneDayTask = false;
      _isNotify = false;
      _taskId = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskCount();
  }

  void getTaskCount() {
    context.read<TaskProvider>().updateTaskCount();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppTheme.lighbackground,
        appBar: AppBar(
          backgroundColor: AppTheme.lighbackground,
        ),
        drawer: CommonDrawer(currentUser: currentUser!),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              //This is the filter for the whole page with 4 parameters
              //"All Time ,Today, weekly, monthly"

              TimeFilter(
                selectedValue: taskProvider.currentTimeFilterStatus,
                onChanged: (newValue) {
                  taskProvider.updateCurrentTimeFilterStatus(newValue!);
                },
                padding: const EdgeInsets.all(8.0),
              ),

              SizedBox(height: 20),
              //Progress part
              Consumer<TaskProvider>(
                builder:
                    (BuildContext context, TaskProvider value, Widget? child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyProgressIndicator(
                        percent: value.taskCompletionPercentage,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total tasks: ${value.totalTask}",
                              style: AppTheme.body,
                            ),
                            Text(
                              "Todo: ${value.todoTask}",
                              style: AppTheme.body,
                            ),
                            Text(
                              "In-Progress: ${value.inProgressTask}",
                              style: AppTheme.body,
                            ),
                            Text(
                              "Done: ${value.completedTask}",
                              style: AppTheme.body,
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),

              SizedBox(height: 20),
              //Task list part

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tasks",
                      style: AppTheme.subheading2,
                    ),
                    GestureDetector(
                      onTap: () => _displayTaskPopUp(
                        popupTitle: "Create New Task",
                        onPressed: () => saveTaskFunction("create"),
                        isCreate: true,
                      ),
                      child: Text("Create Task +"),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicator: ShapeDecoration(
                    color: AppTheme.boldbackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                dividerColor: Colors.grey[300],
                tabs: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Tab(text: "All"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Tab(text: "Todo"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Tab(text: "In-Progress"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Tab(text: "Done"),
                  ),
                ],
              ),

              Expanded(
                child: TabBarView(children: [
                  _taskFetching(taskProvider, "All", context),
                  _taskFetching(taskProvider, "Todo", context),
                  _taskFetching(taskProvider, "In-Progress", context),
                  _taskFetching(taskProvider, "Done", context),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskFetching(
      TaskProvider provider, String status, BuildContext context) {
    return StreamBuilder(
      stream: provider.fetchTasks(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final task = data[index].data() as Map<String, dynamic>;
              Task taskobj = Task.fromMap(task);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    titleController.text = taskobj.name;
                    noteController.text = taskobj.note;

                    _startDateTime = taskobj.startDate;
                    _endDateTime = taskobj.endDate;

                    _priority = taskobj.priority;
                    _status = taskobj.status;

                    _isOneDayTask = checkIsSameDay(
                            startDateTime: _startDateTime,
                            endDateTime: _endDateTime)
                        ? true
                        : false;
                    _isNotify = taskobj.isNotify;

                    _taskId = taskobj.taskId;
                  });

                  _displayTaskPopUp(
                    popupTitle: "Tasks",
                    onPressed: () => saveTaskFunction("update"),
                    isCreate: false,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await provider.deleteTask(taskobj.taskId);
                            },
                            icon: Icons.delete,
                            backgroundColor: Colors.transparent,
                          ),
                        ],
                      ),
                      child: TaskTile(
                        taskName: taskobj.name,
                        endDate: taskobj.endDate,
                        priority: taskobj.priority,
                        status: taskobj.status,
                        onStatusChanged: (newValue) async {
                          if (newValue != null) {
                            try {
                              provider.updateTaskCount();
                              await provider.updateTask({
                                "taskId": taskobj.taskId,
                                "status": newValue,
                              });
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
