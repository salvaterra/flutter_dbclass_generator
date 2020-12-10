void main(){

  var file = """
  Dog: String name; int age;
  """;

  //PARSER
  var models = {};
  for (var m in file.split('\n')) {
    var mdetail = m.split(':');
    if (mdetail.length==2) {
      var mname = mdetail[0].trim();
      var mfields = mdetail[1].trim();
      var fields = {};
      for (var f in mfields.split(';')) {
        var fdetail = f.trim().split(' ');
        if (fdetail.length==2) {
          var fname = fdetail[1];
          var ftype = fdetail[0];
          fields[fname] = ftype;
        }
      }
      models[mname] = Map<String, String>.from(fields);
    }
  }

  // GENERATOR
  var dartSql = {"int":"INTEGER","double":"REAL","String":"TEXT",
    "boolean":"INTEGER", "DateTime": "Integer"};

  for (var model in models.entries){

    var s = "class ${model.key} extends BaseModel{";
    print(s);

    Map<String,String> fields = model.value;
    for (var f in fields.entries)
    {
      var ro="\t${f.value} ${f.key};";
      print(ro);
    };

    s = "\t${model.key}({";
    for (var f in fields.entries)
    {
      s +="this.${f.key}, ";
    };
    s+= "});";
    print(s);

    s = """\t@override
    BaseModel fromJson(Map<String, dynamic> json) => new ${model.key}(\n""";
    for (var f in fields.entries)
    {
      s +="\t\t${f.key}: json[\"${f.key}\"], \n";
    };
    s+= "\t);";
    print(s);

    s= """\t@override
    Map<String, dynamic> toJson() {
      return {\n""";
    for (var f in fields.entries)
    {
      s +="\t\t\t'${f.key}': ${f.key}, \n";
    };
    s+= "\t\t};\n\t}\n}";
    print(s);

    s = """
    class ${model.key}Repository {
  static const String ${model.key.toUpperCase()}_DB_TABLE= '${model.key}';
  static const String CREATE = "CREATE TABLE " + ${model.key.toUpperCase()}_DB_TABLE + " ("
      "id INTEGER PRIMARY KEY,"
  """;
    for (var f in fields.entries)
    {
      s +="\t\t\t\"${f.key} ${dartSql[f.value]}, \"\n";
    };
    s+="""
      ")";

  final dao = Dao<${model.key}>(${model.key}(), tableName: ${model.key.toUpperCase()}_DB_TABLE);
  Future<${model.key}> find(int id) => dao.find(id);
  Future<List<${model.key}>> getAll() => dao.getAll();
  Future<int> insert(${model.key} entry) => dao.insert(entry);
  Future<void> update(${model.key} entry) => dao.update(entry);
  Future<void> delete(${model.key} entry) => dao.delete(entry);
  Future<void> deleteById(int id) => dao.deleteById(id);
}""";
    print(s);
  };
}
