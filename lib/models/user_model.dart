class UserModel {
  int? id;
  String? name;
  int? age;
  String profile;
  UserModel({this.id, this.name, this.age, required this.profile});
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age, 'profile': profile};
  }

  UserModel.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        age = res['age'],
        profile = res['profile'];
}
