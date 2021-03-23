import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  String uuid;
  @HiveField(1)
  String id;
  @HiveField(2)
  bool completed;
  @HiveField(3)
  String title;
  @HiveField(4)
  final int index;
  @HiveField(5)
  final int projectIndex;
  @HiveField(6)
  DateTime time;
  @HiveField(7)
  String detail;

  TaskModel({this.uuid, this.id, this.completed, this.title, this.index, this.projectIndex, this.time, this.detail});
}