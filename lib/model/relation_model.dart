///Relation object to insert into ParseQuery, for get all the object having this [objectId] related with [classname] for the [column]
class Relation {
  String column;
  String classname;
  String objectId;

  Relation(
      {required this.column, required this.classname, required this.objectId});
}
