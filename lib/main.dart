import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'data/models/project.dart';
import 'data/models/task.dart';
import 'application.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProjectModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox("projectsBox");

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none); // debug
  OneSignal.shared.init("cc188ac3-aa16-4864-a10a-e9d61606b42e",);
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

  runApp(Application());
}