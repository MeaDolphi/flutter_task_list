import 'package:hive/hive.dart';

import 'task.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class ProjectModel  {
  @HiveField(0)
  int index;
  @HiveField(1)
  String title;
  @HiveField(2)
  String color;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  List<TaskModel> listTasks;

  ProjectModel(this.index, this.title, this.color, this.date, this.listTasks);
}