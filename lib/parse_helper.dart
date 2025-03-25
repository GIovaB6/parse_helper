library parse_helper;

import 'package:parse_helper/model/relation_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseHelper {
  static Future<ParseObject> fetchParseObjectFromObjId(
    String oid,
    String classname, {
    List<String>? includes,
    int? limit,
    String? orderAsc,
    String? orderDesc,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(classname));
    parseQuery.whereEqualTo('objectId', oid);

    parseQuery.setLimit(limit ?? 10000);

    //Add IncludeObject
    if (includes != null) {
      if (includes.isNotEmpty) {
        parseQuery.includeObject(includes);
      }
    }
    if (orderAsc != null && orderAsc.isNotEmpty) {
      parseQuery.orderByAscending(orderAsc);
    }

    if (orderDesc != null && orderDesc.isNotEmpty) {
      parseQuery.orderByDescending(orderDesc);
    }

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results?.first as ParseObject;
    }

    return ParseObject(classname);
  }

  static Future<List<ParseObject>> fetchListParseObjectFromObjId(
    String classname,
    String column,
    String value, {
    String? orderAsc,
    String? orderDesc,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(classname));
    parseQuery.whereEqualTo(column, value);

    parseQuery.setLimit(10000);

    if (orderAsc != null && orderAsc.isNotEmpty) {
      parseQuery.orderByAscending(orderAsc);
    }

    if (orderDesc != null && orderDesc.isNotEmpty) {
      parseQuery.orderByDescending(orderDesc);
    }

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      if (apiResponse.results != null && apiResponse.results!.isNotEmpty) {
        return apiResponse.results as List<ParseObject>;
      }
    }
    List<ParseObject> emptyList = [];
    return emptyList;
  }

  /// [classname] for query on a parseclass
  /// [conditions] is  a Map of condition ParseQuery.whereEqualTo
  /// [includes] a list of class included in my record for inner visibility of [ParseObject]
  /// [Relation] for query the relation into a raw
  /// [orderAsc] & [orderDesc] if setted order the query for column passed ascending or descending
  static Future<List<ParseObject>> fetchListParseObjectWithCondition(
    String classname, {
    Map<String, dynamic>? conditions,
    List<String>? includes,
    Relation? relation,
    String? orderAsc,
    String? orderDesc,
  }) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject(classname));

    parseQuery.setLimit(10000);

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

    if (relation != null) {
      parseQuery.whereRelatedTo(
          relation.column, relation.classname, relation.objectId);
    }

    if (orderAsc != null && orderAsc.isNotEmpty) {
      parseQuery.orderByAscending(orderAsc);
    }

    if (orderDesc != null && orderDesc.isNotEmpty) {
      parseQuery.orderByDescending(orderDesc);
    }

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      if (apiResponse.results != null && apiResponse.results!.isNotEmpty) {
        return apiResponse.results as List<ParseObject>;
      }
    }
    List<ParseObject> emptyList = [];
    return emptyList;
  }
}
