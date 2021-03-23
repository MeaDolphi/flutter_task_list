import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:uuid/uuid.dart';

import '../../../data/models/project.dart';
import '../../extensions.dart';
import '../../../data/data.dart';
import '../checkbox.dart';
import '../../../data/models/task.dart';
import '../../icons.dart';

import '../../../application.dart';

class BottomSheetProjectCreate extends StatefulWidget {
  DateTime _selectedDate;

  BottomSheetProjectCreate(this._selectedDate);

  final TextEditingController _textProjectNameController = TextEditingController();
  final TextEditingController _textTaskNameController = TextEditingController();

  final GlobalKey<FormFieldState> _textProjectNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _textTaskNameKey = GlobalKey<FormFieldState>();

  final Color _colorProject = Color.fromARGB(255, Random().nextInt(70), Random().nextInt(90), Random().nextInt(90));
  List<TaskModel> _listTasks = [];

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetProjectCreate();
  }
}

class _BottomSheetProjectCreate extends State<BottomSheetProjectCreate> {
  @override
  Widget build(BuildContext context) {
    final Color _colorButton = widget._colorProject.green > widget._colorProject.blue ? Colors.black26 : Colors.deepOrange;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: widget._colorProject
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      provider.update();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      child: Icon(
                        TaskListIcons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget._textProjectNameKey.currentState.validate()) {
                        HiveProvider.addProject(ProjectModel(
                          HiveProvider.getProjectLength(),
                          widget._textProjectNameController.value.text,
                          widget._colorProject.toHex(),
                          widget._selectedDate,
                          widget._listTasks
                        ));

                        provider.update();
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 35  ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: _colorButton,
                      ),
                      child: Text(
                        "Create",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                key: widget._textProjectNameKey,
                controller: widget._textProjectNameController,
                cursorColor: Colors.grey,
                enableSuggestions: false,
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  color: Colors.white,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: "Project Name",
                  hintStyle: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
                validator: (String value) {
                  if (value.length == 0) {
                    return "Specify the name of the project";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width-40,
                height: 1,
                color: Colors.white,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "Tasks",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: TextFormField(
                          key: widget._textTaskNameKey,
                          controller: widget._textTaskNameController,
                          cursorColor: Colors.grey,
                          enableSuggestions: false,
                          style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: "Task Name",
                            hintStyle: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (String value) {
                            if (value.length == 0) {
                              return "Specify the task name";
                            }

                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: 1,
                        color: Colors.white,
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget._textTaskNameKey.currentState.validate()) {
                        setState(() {
                          widget._listTasks.add(TaskModel(
                            uuid: Uuid().v4(),
                            title: widget._textTaskNameController.value.text,
                            index: widget._listTasks.length,
                            projectIndex: HiveProvider.getProjectLength(),
                            completed: false,
                          ));
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 75,
                      height: 35  ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: _colorButton,
                      ),
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget._listTasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width-40,
                      height: 40,
                      child: Row(
                        children: [
                          TaskListCheckBox(
                            size: 24,
                            value: widget._listTasks[index].completed,
                            onChanged: (bool newValue) {
                              setState(() {
                                widget._listTasks[index].completed = newValue;
                              });
                            }
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget._listTasks[index].title,
                                style: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  decorationColor: Colors.white54,
                                  decoration: widget._listTasks[index].completed ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                              )
                            )
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
      )
    );
  }
}