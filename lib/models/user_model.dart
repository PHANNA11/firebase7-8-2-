class UserModel {
  int? id;
  String? name;
  int? age;
  UserModel({this.id, this.name, this.age});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  UserModel.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        age = res['age'];
}
