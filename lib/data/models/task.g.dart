// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      uuid: fields[0] as String,
      id: fields[1] as String,
      completed: fields[2] as bool,
      title: fields[3] as String,
      index: fields[4] as int,
      projectIndex: fields[5] as int,
      time: fields[6] as DateTime,
      detail: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.completed)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.index)
      ..writeByte(5)
      ..write(obj.projectIndex)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.detail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
