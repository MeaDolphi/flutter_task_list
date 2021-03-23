import 'package:flutter/material.dart';

import '../../data/models/project.dart';
import '../../domain/project.dart';

import 'project_card.dart';

class ProjectListWidget extends StatelessWidget {
  DateTime _selectedDate;

  ProjectListWidget(this._selectedDate);

  @override
  Widget build(BuildContext context) {
    List<ProjectModel> _listProjects = ProjectDomain.getProjectsThisDay(_selectedDate);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 450,
      child: ProjectDomain.getCountProjectsThisDay(_selectedDate) > 0
        ? ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ProjectDomain.getCountProjectsThisDay(_selectedDate),
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              if (index == 0) SizedBox(
                width: 20,
              ),
              ProjectCard(
                model: _listProjects[index],
              ),
              SizedBox(
                width: 10,
              ),
            ],
          );
        },
      )
      : SizedBox()
    );
  }
}