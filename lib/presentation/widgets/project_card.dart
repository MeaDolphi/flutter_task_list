import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../widgets/bottom_sheets/project_info.dart';
import '../../domain/tasks.dart';
import '../../data/data.dart';
import '../../data/models/project.dart';
import '../extensions.dart';

import 'bottom_sheets/project_info.dart';
import 'bottom_sheets/task_info.dart';
import 'checkbox.dart';

import '../../application.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel model;

  ProjectCard({this.model});

  @override
  State<StatefulWidget> createState() {
    return _ProjectCard();
  }
}

class _ProjectCard extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).showBottomSheet(
          (context) {
            return BottomSheetProjectInfo(widget.model);
          }
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: HexColor.fromHex(widget.model.color),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: widget.model.title,
                      style: TextStyle(
                        fontFamily: "NotoSans",
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )
                  )
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Container(
                  width: 210,
                  height: 2,
                  color: Colors.white24,
                ),
                if (widget.model.listTasks.length > 0) Container(
                  width: 210/widget.model.listTasks.length*(widget.model.listTasks.length-TasksDomain.getTasksRemain(widget.model.listTasks)),
                  height: 2,
                  color: Colors.white,
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: 210,
              height: 250,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.model.listTasks.length > 5 ? 5 : widget.model.listTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 210,
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TaskListCheckBox(
                          size: 24,
                          value: widget.model.listTasks[index].completed,
                          onChanged: (bool newValue) {
                            setState(() {
                              widget.model.listTasks[index].completed = newValue;

                              if (newValue && widget.model.listTasks[index].time != null) {
                                OneSignalProvider.deleteNotification(widget.model.listTasks[index].id);
                              }

                              ProjectModel project = HiveProvider.getProject(widget.model.listTasks[index].projectIndex);
                              project.listTasks[widget.model.listTasks[index].index].completed = newValue;
                              HiveProvider.updateProject(widget.model.listTasks[index].projectIndex, project);
  
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
                                  return BottomSheetTaskInfo(widget.model.listTasks[index], widget.model.date);
                                }
                              );
                            }, //
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget.model.listTasks[index].title,
                                style: TextStyle(
                                  fontFamily: "NotoSans",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  decorationColor: Colors.white54,
                                  decorationThickness: 2,
                                  decoration: widget.model.listTasks[index].completed ? TextDecoration.lineThrough : TextDecoration.none,
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
              height: 15,
            ),
            if (widget.model.listTasks.length > 5) Row(
              children: [
                Text(
                  "+ ${widget.model.listTasks.length-5} Tasks",
                  style: TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}