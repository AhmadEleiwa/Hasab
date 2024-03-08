import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileReader {
  static Future<String> getLocalPath() async {
    var dir = await getApplicationCacheDirectory();
    return dir.path;
  }

  static Future<File> getLocalFile(String fileName) async {
    String path = await getLocalPath();
    return File('$path/$fileName.txt');
  }

  static Future<File> writeFile(
    String fileName,
    String str,
  ) async {
    File file = await getLocalFile(fileName);

    return file.writeAsString(str);
  }

  static Future<String> readFile(String fileName) async {
    try {
      final file = await getLocalFile(fileName);
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return "";
    }
  }
}
