import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
    '${alpha.toRadixString(16).padLeft(2, '0')}'
    '${red.toRadixString(16).padLeft(2, '0')}'
    '${green.toRadixString(16).padLeft(2, '0')}'
    '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension DateTimeExtension on DateTime {
  DateTime getCurrentDate() {
    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  String getSelectedDateInString(DateTime firstDate, DateTime secondDate) {
    if (firstDate.difference(secondDate).inDays != 0) {
      if (firstDate.difference(secondDate).inDays == 1) {
        return "Tomorrow";
      }

      if (firstDate.difference(secondDate).inDays == -1) {
        return "Yesterday";
      }

      return DateFormat("dd/MM/yyyy").format(firstDate);
    }
    else {
      return "Today";
    }
  }

  String toOneSignalDate() {
    int timeZoneOffsetInMinutes = DateTime.now().timeZoneOffset.inMinutes;
    bool typeGMT = timeZoneOffsetInMinutes < 0 ? true : false;

    timeZoneOffsetInMinutes = timeZoneOffsetInMinutes < 0 ? timeZoneOffsetInMinutes*(-1) : timeZoneOffsetInMinutes;

    int timeZoneOffsetHours = timeZoneOffsetInMinutes~/60;
    int timeZoneOffsetMinutes = timeZoneOffsetInMinutes-timeZoneOffsetHours*60;

    return "${this.year}"+
    "-"+
    "${this.month.toString().length < 2 ? "0"+this.month.toString() : this.month}"+
    "-"+
    "${this.day.toString().length < 2 ? "0"+this.day.toString() : this.day} "+
    "${this.hour.toString().length < 2 ? "0"+this.hour.toString() : this.hour}"+
    ":"+
    "${this.minute.toString().length < 2 ? "0"+this.minute.toString() : this.minute}"+
    ":00 GMT"+
    "${typeGMT ? "-" : "+"}"+
    "${timeZoneOffsetHours.toString().length < 2 ? "0"+timeZoneOffsetHours.toString() : timeZoneOffsetHours}"+
    "${timeZoneOffsetMinutes.toString().length < 2 ? "0"+timeZoneOffsetMinutes.toString() : timeZoneOffsetMinutes}";
  }
}

