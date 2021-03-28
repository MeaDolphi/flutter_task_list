import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:uuid/uuid.dart';

import '../../../data/models/project.dart';
import '../../extensions.dart';
import '../../../data/data.dart';
import '../checkbox.dart';
import '../../../data/models/task.dart';
import '../../icons.dart';

import 'task_info.dart';

import '../../screens/home.dart';
import '../../../application.dart';

class BottomSheetProjectInfo extends StatefulWidget {
  final ProjectModel _project;

  BottomSheetProjectInfo(this._project);

  final TextEditingController _textProjectNameController = TextEditingController();
  final TextEditingController _textTaskNameController = TextEditingController();

  final GlobalKey<FormFieldState> _textTaskNameKey = GlobalKey<FormFieldState>();
  
  @override
  State<StatefulWidget> createState() {
    return _BottomSheetProjectInfo();
  }
}

class _BottomSheetProjectInfo extends State<BottomSheetProjectInfo> {
  FocusNode _textProjectNameNode;
  FocusNode _textTaskNameNode;

  @override
  void initState() {
    super.initState();

    _textProjectNameNode = FocusNode();
    _textTaskNameNode = FocusNode();
  }

  @override
  void dispose() {
    _textProjectNameNode.dispose();
    _textTaskNameNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color _colorButton = HexColor.fromHex(widget._project.color).green > HexColor.fromHex(widget._project.color).blue ? Colors.black26 : Colors.deepOrange;

    return GestureDetector(
      onTap: () {
        _textProjectNameNode.unfocus();
        _textTaskNameNode.unfocus();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: HexColor.fromHex(widget._project.color),
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
                      Navigator.pop(context);
                      provider.update();
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
                      if (widget._textProjectNameController.value.text.length > 0) {
                        widget._project.title = widget._textProjectNameController.value.text;
                      }
                      HiveProvider.updateProject(widget._project.index, widget._project);

                      provider.update();
                      Navigator.pop(context);
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
                        "Update",
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
                controller: widget._textProjectNameController,
                focusNode: _textProjectNameNode,
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
                  hintText: widget._project.title,
                  hintStyle: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
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
                          focusNode: _textTaskNameNode,
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
                          widget._project.listTasks.add(TaskModel(
                            uuid: Uuid().v4(),
                            title: widget._textTaskNameController.value.text,
                            index: widget._project.listTasks.length,
                            projectIndex: widget._project.index,
                            completed: false,
                          ));
                        });

                        if (widget._textProjectNameController.value.text.length > 0) {
                          widget._project.title = widget._textProjectNameController.value.text;
                        }
                        HiveProvider.updateProject(widget._project.index, widget._project);
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
                  itemCount: widget._project.listTasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width-40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).showBottomSheet(
                            (context) {
                              return BottomSheetTaskInfo(widget._project.listTasks[index], widget._project.date);
                            }
                          );
                        },
                        child: Row(
                          children: [
                            TaskListCheckBox(
                              size: 24,
                              value: widget._project.listTasks[index].completed,
                              onChanged: (bool newValue) {
                                setState(() {

                                  if (newValue && widget._project.listTasks[index].time != null) {
                                    OneSignalProvider.deleteNotification(widget._project.listTasks[index].id);
                                  }

                                  widget._project.listTasks[index].completed = newValue;
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
                                  text: widget._project.listTasks[index].title,
                                  style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    decorationColor: Colors.white54,
                                    decoration: widget._project.listTasks[index].completed ? TextDecoration.lineThrough : TextDecoration.none,
                                  ),
                                )
                              )
                            )
                          ],
                        ),
                      )
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