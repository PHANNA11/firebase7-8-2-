class UserModel {
  int? id;
  String? name;
  int? age;
  String profile;
  Address address;
  UserModel(
      {this.id,
      this.name,
      this.age,
      required this.profile,
      required this.address});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'profile': profile,
      'address': address.toJson()
    };
  }

  UserModel.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        age = res['age'],
        profile = res['profile'],
        address = Address.fromJson(res['address']);
}

class Address {
  String? city;
  String? street;
  int? zipcode;
  Map<String, dynamic> toJson() {
    return {'city': city, 'street': street, 'zipcode': zipcode};
  }

  Address.fromJson(Map<String, dynamic> res)
      : city = res['city'],
        street = res['street'],
        zipcode = res['zipcode'];
}
