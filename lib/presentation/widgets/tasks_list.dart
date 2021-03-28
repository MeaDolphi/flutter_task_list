import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/data.dart';
import '../../data/models/project.dart';
import '../../data/models/task.dart';
import '../../domain/tasks.dart';
import '../screens/home.dart';

import 'checkbox.dart';
import 'bottom_sheets/task_info.dart';

import '../../application.dart';

class TasksListWidget extends StatefulWidget {
  DateTime _selectedDate;

  TasksListWidget(this._selectedDate);

  @override
  State<StatefulWidget> createState() {
    return _TasksListWidget();
  }
}

class _TasksListWidget extends State<TasksListWidget> {
  @override
  Widget build(BuildContext context) {
    List<TaskModel> _listTasks = TasksDomain.getTasksThisDay(widget._selectedDate);

    if (_listTasks.isEmpty) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "${TasksDomain.getTasksRemain(_listTasks)} Tasks remain",
                style: TextStyle(
                  fontFamily: "NotoSans",
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ), // tasksDomain.getTasksRemain(widget.listTasks)
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width-40,
                height: 2,
                color: Colors.black26,
              ),
              Container(
                width: (MediaQuery.of(context).size.width-40)/_listTasks.length*(_listTasks.length-TasksDomain.getTasksRemain(_listTasks)),
                height: 2,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width-40,
            height: 400,
            child: ListView.builder(
              itemCount: _listTasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 210,
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TaskListCheckBox(
                        size: 24,
                        checkColor: Colors.white,
                        borderColor: Colors.black,
                        fillColor: Colors.black,
                        value: _listTasks[index].completed,
                        onChanged: (bool newValue) {
                          setState(() {
                            _listTasks[index].completed = newValue;

                            if (newValue && _listTasks[index].time != null) {
                              OneSignalProvider.deleteNotification(_listTasks[index].id);
                            }

                            ProjectModel project = HiveProvider.getProject(_listTasks[index].projectIndex);
                            project.listTasks[_listTasks[index].index].completed = newValue;
                            HiveProvider.updateProject(_listTasks[index].projectIndex, project);

                            provider.update();
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Scaffold.of(context).showBottomSheet(
                              (context) {
                                return BottomSheetTaskInfo(_listTasks[index], widget._selectedDate);
                              }
                            );
                          }, //
                          child:RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: _listTasks[index].title,
                              style: TextStyle(
                                fontFamily: "NotoSans",
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decorationColor: Colors.black38,
                                decorationThickness: 2,
                                decoration: _listTasks[index].completed ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                            )
                          )
                        )
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ]
      )
    );
  }
}