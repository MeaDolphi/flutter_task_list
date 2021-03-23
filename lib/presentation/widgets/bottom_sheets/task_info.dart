import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/tasks.dart';
import '../../../data/data.dart';
import '../../../data/models/project.dart';
import '../../extensions.dart';
import '../../../data/models/task.dart';
import '../../icons.dart';

import '../../../application.dart';

class BottomSheetTaskInfo extends StatefulWidget {
  final TaskModel _task;
  final DateTime _selectedDate;

  BottomSheetTaskInfo(this._task, this._selectedDate);

  final TextEditingController _textTaskNameController = TextEditingController();
  final TextEditingController _textDetailController = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetTaskInfo();
  }
}

class _BottomSheetTaskInfo extends State<BottomSheetTaskInfo> {
  @override
  Widget build(BuildContext context) {
    final ProjectModel _project = HiveProvider.getProject(widget._task.projectIndex);
    final Color _colorButton = HexColor.fromHex(_project.color).green > HexColor.fromHex(_project.color).blue ? Colors.black26 : Colors.deepOrange;
    bool _enableReminder = !widget._task.completed;

    if (widget._task.time != null && widget._task.time.millisecondsSinceEpoch < DateTime(1, 1, 1, DateTime.now().hour, DateTime.now().minute+1).millisecondsSinceEpoch) {
      widget._task.uuid = Uuid().v4();
      widget._task.time = null;

      TasksDomain.updateTask(widget._task);
    }

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
          color: HexColor.fromHex(_project.color),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
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
                        if (widget._textTaskNameController.value.text.length > 0) {
                          widget._task.title = widget._textTaskNameController.value.text;
                        }

                        if (widget._task.time != null) {
                          DateTime _dateNotification = widget._selectedDate.add(Duration(hours: widget._task.time.hour, minutes: widget._task.time.minute));

                          if (widget._task.detail != null && widget._task.detail.length > 0) {
                            OneSignalProvider.addNotificationWithReplacement(
                              widget._task,
                              _dateNotification.toOneSignalDate(),
                            );
                          }
                          else {
                            OneSignalProvider.addNotificationWithReplacement(
                              widget._task,
                              _dateNotification.toOneSignalDate(),
                            );
                          }
                        }

                        TasksDomain.updateTask(widget._task);

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
                  controller: widget._textTaskNameController,
                  cursorColor: Colors.grey,
                  enableSuggestions: false,
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: widget._task.title,
                    hintStyle: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
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
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Project",
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      HiveProvider.getProject(widget._task.projectIndex).title,
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                if (_enableReminder) Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time",
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCustomTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          onFailValidation: (context) {
                            Navigator.push(context, PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 64,
                                        color: _colorButton,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "You are trying to specify the past tense!",
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                          fontFamily: "OpenSans",
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(scale: animation, child: child),
                                );
                              }
                            ));
                          },
                          selectableTimePredicate: (time) {
                            if (widget._selectedDate == DateTime(0).getCurrentDate()) {
                              return time.hour == TimeOfDay.now().hour ? time.minute >= TimeOfDay.now().minute : time.hour >= TimeOfDay.now().hour;
                            }
                            else {
                              return true;
                            }
                          },
                        ).then((time) {
                          if (time != null) {
                            setState(() {
                              widget._task.time = DateTime(1, 1, 1, time.hour, time.minute);
                            });
                          }
                        });
                      },
                      child: Text(
                        widget._task.time == null ? "Select" : TimeOfDay(hour: widget._task.time.hour, minute: widget._task.time.minute).format(context),
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: widget._task.time == null ? Colors.white38 : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_enableReminder) SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Completed",
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    CupertinoSwitch(
                      activeColor: _colorButton,
                      value: widget._task.completed,
                      onChanged: (bool newValue) {
                        setState(() {
                          if (newValue && widget._task.time != null) {
                            widget._task.time = null;

                            OneSignalProvider.deleteNotification(widget._task.id);
                          }

                          widget._task.completed = newValue;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Detail",
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (widget._textDetailController.value.text.length > 0) {
                          setState(() {
                            widget._task.detail = widget._textDetailController.value.text;
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: _colorButton,
                        ),
                        child: Text(
                          widget._task.detail == null ? "Enter" : "Change",
                          style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width-40,
                  height: 60,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: widget._textDetailController,
                        cursorColor: Colors.grey,
                        enableSuggestions: false,
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width-40,
                        height: 1,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget._task.detail != null) Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget._task.detail,
                          style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      )
                    ],
                  )
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          )
        )
      )
    );
  }
}