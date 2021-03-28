import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../domain/tasks.dart';

import 'models/project.dart';
import 'models/task.dart';

class HiveProvider {
  static void addProject(ProjectModel project) async {
    Box<dynamic> box = Hive.box("projectsBox");
    box.put(box.length, project);
  }

  static void updateProject(int index, ProjectModel project) async {
    Box<dynamic> box = Hive.box("projectsBox");
    await box.put(index, project);
  }

  static ProjectModel getProject(int index) {
    Box<dynamic> box = Hive.box("projectsBox");
    return box.get(index);
  }

  static int getProjectLength() {
    Box<dynamic> box = Hive.box("projectsBox");

    return box.length;
  }

  static void deleteProject(int index) async {
    Box<dynamic> box = Hive.box("projectsBox");
    await box.delete(index);
  }

  static void clearProjects() async {
    Box<dynamic> box = Hive.box("projectsBox");
    await box.clear();
  }

  static List<TaskModel> getTasks() {
    Box<dynamic> box = Hive.box("projectsBox");
    List<TaskModel> listTasks = [];

    for (int i = 0; i < box.length; i++) {
      ProjectModel project = box.get(i);

      listTasks.addAll(project.listTasks);
    }

    return listTasks;
  }
}

class OneSignalProvider {
  static Dio _dio = Dio();

  static String _appID = ""; // Enter your APP ID from OneSignal
  static String _restAPIKey = ""; // Enter your REST API from OneSignal

  static const String _notificationURL = "https://onesignal.com/api/v1/notifications/";

  static Future<Response> _getResponseByAddNotification(TaskModel task, String date) async {
    String userID;

    await OneSignal.shared.getPermissionSubscriptionState().then(
      (value) {
        userID = value.subscriptionStatus.userId;
      }
    );

    Response response = await _dio.post(
      _notificationURL,
      options: Options(
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": "Basic "+_restAPIKey,
        }
      ),
      data: {
        "app_id": _appID,
        "include_player_ids": [userID],
        "external_id": task.uuid,
        "send_after": date,
        "headings": {
          "en": task.title
        },
        "contents": {
          "en": task.detail != null && task.detail.length > 0 ? task.detail : "Empty"
        }
      }
    );

    if (response.data["id"] != null) {
      task.id = response.data["id"];
    }

    return response;
  }

  static void addNotification(TaskModel task, String date) async {
    await _getResponseByAddNotification(task, date);
  }

  static Future<Response> deleteNotification(String notificationID) async {
    Response response = await _dio.delete(_notificationURL+notificationID+"?app_id="+_appID, options: Options(
      headers: {
        "Authorization": "Basic "+_restAPIKey,
      }
    ));

    return response;
  }

  static void addNotificationWithReplacement(TaskModel task, String date) async {
    Response responseAddNotification = await _getResponseByAddNotification(task, date);

    if (responseAddNotification.data["id"] != null) {
      Response responseDeleteNotification = await deleteNotification(responseAddNotification.data["id"]);

      if (responseDeleteNotification.statusCode == 200) {
        TasksDomain.changeUUID(task);
        TasksDomain.updateTask(task);

        await _getResponseByAddNotification(task, date);
      }
    }
  }
}