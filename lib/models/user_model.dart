class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String emergencyContact1;
  final String emergencyContact2;
  final String emergencyEmail;
  final String nearestPoliceStation;
  final String bloodGroup;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.emergencyContact1,
    required this.emergencyContact2,
    required this.emergencyEmail,
    required this.nearestPoliceStation,
    required this.bloodGroup,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'emergencyContact1': emergencyContact1,
      'emergencyContact2': emergencyContact2,
      'emergencyEmail': emergencyEmail,
      'nearestPoliceStation': nearestPoliceStation,
      'bloodGroup': bloodGroup,
      'address': address,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      emergencyContact1: map['emergencyContact1'] ?? '',
      emergencyContact2: map['emergencyContact2'] ?? '',
      emergencyEmail: map['emergencyEmail'] ?? '',
      nearestPoliceStation: map['nearestPoliceStation'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
