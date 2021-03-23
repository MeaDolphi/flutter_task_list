import 'package:flutter/material.dart';

class UpdaterProvider extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}