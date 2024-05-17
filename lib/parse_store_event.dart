library parse_helper;

import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

const String classname = "Event";

class ParseStoreEvent {
  static Future<bool> saveEvent(ParseUser user, String action) async {
    var event = ParseObject(classname)
      ..set('action', action)
      ..set('owner', user);
    ParseResponse response = await event.save();

    if (response.success) {
      return true;
    } else {
      debugPrint("Error for saving with error ${response.error}");
      return false;
    }
  }
}
