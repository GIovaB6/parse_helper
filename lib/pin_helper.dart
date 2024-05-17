library parse_helper;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinHelper {
  static Future<bool> pinObjects(
      List<ParseObject> objects, String classname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(classname);
    String? lastObjects = prefs.getString(classname);

    StringBuffer objectIds = StringBuffer();

    for (ParseObject obj in objects) {
      //print('pin ' + obj.toString());

      if (lastObjects == null || !lastObjects.contains(obj.objectId!)) {
        await obj.pin();
        // print('pin done');
        objectIds.write(obj.objectId);
        objectIds.write(';');
      }
    }

    if (lastObjects != null) {
      return await prefs.setString(
          classname, objectIds.toString() + lastObjects);
    } else {
      return await prefs.setString(classname, objectIds.toString());
    }
  }

  static Future<bool> pinUser(ParseUser user, String classname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(classname);
    String? lastObjects = prefs.getString(classname);

    StringBuffer objectIds = StringBuffer();

    //print('pin ' + obj.toString());

    if (lastObjects == null || !lastObjects.contains(user.objectId!)) {
      await user.pin();
      // print('pin done');
      objectIds.write(user.objectId);
      objectIds.write(';');
    }

    if (lastObjects != null) {
      return await prefs.setString(
          classname, objectIds.toString() + lastObjects);
    } else {
      return await prefs.setString(classname, objectIds.toString());
    }
  }

  static Future<List<String>> userFromPin(String classname) async {
    List<String> objectList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? objectIds = prefs.getString(classname);

    //print(objectIds);

    if (objectIds != null) {
      List<String> objectIdList = objectIds.split(';');

      for (String objectId in objectIdList) {
        objectList.add(objectId);
      }
    }

    return objectList;
  }

  static Future<List<ParseObject>> objectsFromPin(String classname) async {
    List<ParseObject> objectList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? objectIds = prefs.getString(classname);

    //print(objectIds);

    if (objectIds != null) {
      List<String> objectIdList = objectIds.split(';');

      for (String objectId in objectIdList) {
        var obj = await ParseObject(classname).fromPin(objectId);
        if (obj != null) {
          objectList.add(obj as ParseObject);
        } else {
          if (kDebugMode) {
            print('object null');
          }
        }
      }
    }

    return objectList;
  }

  static Future<ParseObject> objectFromPin(
      String classname, String myObjectId) async {
    ParseObject object = ParseObject("Ticket");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? objectIds = prefs.getString(classname);

    //print(objectIds);

    if (objectIds != null) {
      List<String> objectIdList = objectIds.split(';');

      for (String objectId in objectIdList) {
        var obj = await ParseObject(classname).fromPin(objectId);
        if (obj != null && objectId == myObjectId) {
          object = obj as ParseObject;
        } else {}
      }
    }

    return object;
  }

  static Future<bool> usernameExists(String username) async {
    QueryBuilder<ParseUser> queryUsers =
        QueryBuilder<ParseUser>(ParseUser.forQuery());
    queryUsers.whereEqualTo("username", username);
    final ParseResponse apiResponse = await queryUsers.query();

    if (apiResponse.success && apiResponse.results != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<dynamic> refreshConfigs() async {
    final ParseResponse response = await ParseConfig().getConfigs();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (response.success) {
      debugPrint('We have our configs.');
      prefs.setString("config", json.encode(response.result));
      return response.result;
    }

    return null;
  }

  static Future<dynamic> getConfigs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? configJson = prefs.getString("config");
    if (configJson != null) {
      return jsonDecode(configJson);
    } else {
      return await refreshConfigs();
    }
  }

  static FutureOr<bool> pinCustomObjects<T>(List<T> objects, String classname,
      Future<Map<String, dynamic>> Function(T t) toJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(classname);

    StringBuffer objectsJson = StringBuffer();

    for (T obj in objects) {
      final Map<String, dynamic> objectMap = await toJson(obj);
      final String json = jsonEncode(objectMap);
      objectsJson.write(json);
      objectsJson.write(';');
    }

    return await prefs.setString(classname, objectsJson.toString());
  }

  static Future<List<T>> customObjectsFromPin<T>(String classname,
      FutureOr<T> Function(Map<String, dynamic> json) fromJson) async {
    List<T> objectList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? objectsJson = prefs.getString(classname);

    if (objectsJson != null) {
      List<String> objectJsonList = objectsJson.split(';');
      if (objectJsonList.isNotEmpty) {
        // Remove last because split create at last one element = ""
        objectJsonList.removeLast();
      }

      for (String objectJson in objectJsonList) {
        var json = jsonDecode(objectJson);
        var obj = await fromJson(json);
        objectList.add(obj);
      }
    }

    return objectList;
  }
}
