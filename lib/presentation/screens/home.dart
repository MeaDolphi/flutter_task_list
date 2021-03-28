import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../domain/project.dart';
import '../widgets/updater.dart';
import '../widgets/bottom_sheets/project_create.dart';
import '../widgets/tasks_list.dart';
import '../widgets/project_list.dart';
import '../extensions.dart';
import '../icons.dart';
import '../../data/data.dart';

import '../../application.dart';

Color defaultColor;
Color backgroundColor;

class HomeScreen extends StatefulWidget {
  DateTime _selectedDate = DateTime(0).getCurrentDate();

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      defaultColor = Color.fromARGB(255, 222, 222, 222);
      backgroundColor = Color.fromARGB(255, 0, 0, 0);
    }
    else {
      defaultColor = Color.fromARGB(255, 33, 33, 33);
      backgroundColor = Color.fromARGB(255, 255, 255, 255);
    }

    return Consumer<UpdaterProvider>(
      builder: (_, updaterProvider, __) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Builder(
            builder: (context) {
              return SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: widget._selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2099),
                                    ).then((date) {
                                      if (date != null) {
                                        setState(() {
                                          widget._selectedDate = date;
                                        });

                                        provider.update();
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        DateTime(0).getSelectedDateInString(widget._selectedDate, DateTime(0).getCurrentDate()),
                                        style: TextStyle(
                                          fontFamily: "NotoSans",
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: defaultColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        child: Icon(
                                          TaskListIcons.chevron_down,
                                          size: 12,
                                          color: defaultColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showMenu(
                                        context: context,
                                        position: RelativeRect.fromLTRB(100, MediaQuery.of(context).viewPadding.top, 0, 0),
                                        items: [
                                          PopupMenuItem(
                                            value: 0,
                                            child: Text(
                                              "Delete projects of the day",
                                              style: TextStyle(
                                                fontFamily: "OpenSans",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(
                                              "Delete all projects",
                                              style: TextStyle(
                                                fontFamily: "OpenSans",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ]
                                      ).then((value) {
                                        if (value != null) {
                                          if (value == 0) {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                opaque: false,
                                                pageBuilder: (BuildContext context, _, __) {
                                                  return AlertDialog(
                                                    title: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.warning_rounded,
                                                          size: 64,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            "Are you sure you want to clear projects for that day?",
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          await ProjectDomain.clearProjectsThisDay(widget._selectedDate);
                                                          provider.update();
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            fontFamily: "OpenSans",
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                            fontFamily: "OpenSans",
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                                transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: ScaleTransition(scale: animation, child: child),
                                                  );
                                                }
                                              )
                                            );
                                          }

                                          if (value == 1) {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                opaque: false,
                                                pageBuilder: (BuildContext context, _, __) {
                                                  return AlertDialog(
                                                    title: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.warning_rounded,
                                                          size: 64,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            "Are you sure you want to clear all projects?",
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          await HiveProvider.clearProjects();
                                                          provider.update();
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            fontFamily: "OpenSans",
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                            fontFamily: "OpenSans",
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                                transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: ScaleTransition(scale: animation, child: child),
                                                  );
                                                }
                                              )
                                            );
                                          }
                                        }
                                      });
                                    });
                                  },
                                  child: Icon(
                                    TaskListIcons.trash,
                                    size: 24,
                                    color: defaultColor,
                                  ),
                                )
                              ],
                            )
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Projects",
                                  style: TextStyle(
                                    fontFamily: "NotoSans",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: defaultColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          ProjectListWidget(widget._selectedDate),
                          SizedBox(
                            height: 20,
                          ),
                          if (ProjectDomain.getCountProjectsThisDay(widget._selectedDate) > 0) TasksListWidget(widget._selectedDate)
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Scaffold.of(context).showBottomSheet(
                                    (context) {
                                      return BottomSheetProjectCreate(widget._selectedDate);
                                    }
                                  );
                                },
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    color: Colors.deepOrange,
                                  ),
                                  child: Icon(
                                    TaskListIcons.plus,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ]
                )
              );
            }
          )
        );
      }
    );
  }
}