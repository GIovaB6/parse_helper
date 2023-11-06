library parse_helper;


import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';


// import 'logger.dart';
class ParseHelper {

  static Future<ParseObject> fetchParseObjectFromObjId(String oid,String classname) async {

    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject(classname));
    parseQuery.whereEqualTo('objectId',oid);

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results?.first as ParseObject;
    }

    return new ParseObject(classname);
  }


  static Future<List<ParseObject>> fetchListParseObjectFromObjId(String classname,String column,String value) async {

    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject(classname));
    parseQuery.whereEqualTo(column,value);

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      if(apiResponse.results != null && apiResponse.results!.length > 0) {
        return apiResponse.results as List<ParseObject>;
      }
    }
    List<ParseObject> emptyList = [];
    return emptyList;
  }



  //* classname => The name of parse Class
  //* conditions => a Map of condition where/equalTo
  //* includes => a list of class included in my record for inner visibility of objects

  static Future<List<ParseObject>> fetchListParseObjectWithCondition(String classname ,Map<String,dynamic>? conditions,List<String>? includes) async {


    final QueryBuilder<ParseObject> parseQuery =

      
    QueryBuilder<ParseObject>(ParseObject(classname ));

    if(conditions != null) {
      //Add where Condition
      conditions.forEach((key, value) {
        parseQuery.whereEqualTo(key, value);
      });

    }
    //Add IncludeObject
    if(includes != null) {
      if(includes.isNotEmpty) {
        parseQuery.includeObject(includes);
      }
    }

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      if(apiResponse.results != null && apiResponse.results!.length > 0) {
        return apiResponse.results as List<ParseObject>;
      }
    }
    List<ParseObject> emptyList = [];
    return emptyList;
  }
  
}




  // static Future<String> fetchCustomerFromShared() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? stripeCustomerId = prefs.getString('stripeCustomerId');

  //   if(stripeCustomerId != null) {
  //     // Logger.log("MY STRIPE CUSTOMER ID" + stripeCustomerId);
  //     return stripeCustomerId;
  //   } else {
  //     //  Logger.log("NOT STRIPE CUSTOMER ID");
  //     return "";
  //    }

  // }
  
  // static Future<String> fetchCustomerId({
  //   required BuildContext context,
  // }) async{


  //   ParseUser currentUser = await ParseUser.currentUser();

  //   currentUser.update();
  //   //Check if customer
  //   if(currentUser.get("customerId") == null) {
  //     // Logger.log("NOT CUSTOMER");
  //     //TODO DialogUtils.showStrongErrorDialog(
  //     //     context: context,
  //     //     message: "lbl_attention".tr,
  //     //     title: "lbl_attention".tr
  //     // );
  //     return "";
  //   } else {
  //     // Logger.log("IS ALREADY CUSTOMER ");
  //     return currentUser.get("customerId") as String;
  //   }
  // }
