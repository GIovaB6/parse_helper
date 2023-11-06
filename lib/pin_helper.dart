library parse_helper;

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinHelper {

    static Future<bool> pinObjects(List<ParseObject> objects, String classname) async {
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
    return await prefs.setString(classname, objectIds.toString() + lastObjects);
  } else {
    return await prefs.setString(classname, objectIds.toString());
  }
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

            // print('object null');
          }
        }
      }

      return objectList;
    }


    static Future<ParseObject> objectFromPin(String classname, String myObjectId) async {
      ParseObject object = new ParseObject(classname);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? objectIds = prefs.getString(classname);

      //print(objectIds);

      if (objectIds != null) {
        List<String> objectIdList = objectIds.split(';');

        for (String objectId in objectIdList) {
          var obj = await ParseObject(classname).fromPin(objectId);
          if (obj != null && objectId == myObjectId) {
            object = obj as ParseObject;
          } else {
            print('object null');
          }
        }
      }

      return object;
    }


    static Future<bool> pinUser(ParseUser user, String classname) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(classname);
      String? lastObjects = prefs.getString(classname);
      StringBuffer objectIds = StringBuffer();

        if (lastObjects == null || !lastObjects.contains(user.objectId!)) {

          await user.pin();

          objectIds.write(user.objectId);
          objectIds.write(';');

      }

      if (lastObjects != null) {
        return await prefs.setString(classname, objectIds.toString() + lastObjects);
      } else {
        return await prefs.setString(classname, objectIds.toString());
      }
    }


    static Future<List<String>> userFromPin(String classname) async {
      List<String> objectList = [];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? objectIds = prefs.getString(classname);



      if (objectIds != null) {
        List<String> objectIdList = objectIds.split(';');

        for (String objectId in objectIdList) {
            objectList.add(objectId);
          }
      }

      return objectList;
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

}