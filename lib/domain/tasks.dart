import 'package:uuid/uuid.dart';

import '../data/models/project.dart';
import '../data/models/task.dart';
import '../data/data.dart';

import 'project.dart';

class TasksDomain {
  static int getTasksRemain(List<TaskModel> listTasks) {
    int counter = 0;

    for (int i = 0; i < listTasks.length; i++) {
      if (listTasks[i].completed == false) {
        counter++;
      }
    }

    return counter;
  }

  static void updateTask(TaskModel task) {
    ProjectModel project = HiveProvider.getProject(task.projectIndex);
    project.listTasks[task.index] = task;

    HiveProvider.updateProject(project.index, project);
  }

  static List<TaskModel> getTasksThisDay(DateTime thisDay) {
    List<ProjectModel> listProjectsThisDay = ProjectDomain.getProjectsThisDay(thisDay);
    List<TaskModel> listTasksThisDay = [];

    for (int i = 0; i < listProjectsThisDay.length; i++) {
      listTasksThisDay.addAll(listProjectsThisDay[i].listTasks);
    }

    return listTasksThisDay;
  }

  static void changeUUID(TaskModel task) {
    task.uuid = Uuid().v4();
  }
}