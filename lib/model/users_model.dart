class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? secondname;

  UserModel({this.uid, this.email, this.firstname, this.secondname});

  //data fetching from server side//

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstname: map['firstName'],
        secondname: map['SecondName']);
  }

  //sending data to our server//

  Map<String, dynamic> tomap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstname,
      'SecondName': secondname
    };
  }
}
