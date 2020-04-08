class UserModel {
  String name;
  String age;

  UserModel({this.name, this.age});

  UserModel.fromJson(Map<String, dynamic> parsedJSON)
      : name = parsedJSON['name'],
        age = parsedJSON['age'];
}
