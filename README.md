# flutter_dbclass_generator
Simple script in Dart to Generate classes. Keep your code clean and reusable.

Go from this:

`Dog: String name; int age;`

to this:

```
class Dog extends BaseModel {
  String name;
  int age;

  Dog({
    this.name,
    this.age,
  });

  @override
  BaseModel fromJson(Map<String, dynamic> json) => new Dog(
        name: json["name"],
        age: json["age"],
      );

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}

class DogRepository {
  static const String DOG_DB_TABLE = 'Dog';
  static const String CREATE = "CREATE TABLE " +
      DOG_DB_TABLE +
      " ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT, "
          "age INTEGER, "
          ")";

  final dao = Dao<Dog>(Dog(), tableName: DOG_DB_TABLE);

  Future<Dog> find(int id) => dao.find(id);

  Future<List<Dog>> getAll() => dao.getAll();

  Future<int> insert(Dog entry) => dao.insert(entry);

  Future<void> update(Dog entry) => dao.update(entry);

  Future<void> delete(Dog entry) => dao.delete(entry);

  Future<void> deleteById(int id) => dao.deleteById(id);
}
```
