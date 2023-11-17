library parse_helper;

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseHelper {
  static Future<ParseObject> fetchParseObjectFromObjId(
      String oid, String classname) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(classname));
    parseQuery.whereEqualTo('objectId', oid);

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results?.first as ParseObject;
    }

    return new ParseObject(classname);
  }

  static Future<List<ParseObject>> fetchListParseObjectFromObjId(
      String classname, String column, String value) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(classname));
    parseQuery.whereEqualTo(column, value);

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      if (apiResponse.results != null && apiResponse.results!.length > 0) {
        return apiResponse.results as List<ParseObject>;
      }
    }
    List<ParseObject> emptyList = [];
    return emptyList;
  }

  //* classname => The name of parse Class
  //* conditions => a Map of condition where/equalTo
  //* includes => a list of class included in my record for inner visibility of objects

  static Future<List<ParseObject>> fetchListParseObjectWithCondition(
      String classname,
      Map<String, dynamic>? conditions,
      List<String>? includes) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(classname));

    if (conditions != null) {
      //Add where Condition
      conditions.forEach((key, value) {
        parseQuery.whereEqualTo(key, value);
      });
    }
    //Add IncludeObject
    if (includes != null) {
      if (includes.isNotEmpty) {
        parseQuery.includeObject(includes);
      }
    }

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      if (apiResponse.results != null && apiResponse.results!.length > 0) {
        return apiResponse.results as List<ParseObject>;
      }
    }
    List<ParseObject> emptyList = [];
    return emptyList;
  }
}
