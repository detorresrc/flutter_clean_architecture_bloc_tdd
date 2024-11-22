import 'dart:convert';

import 'package:tdd_tutorial/core/utility/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.createdAt,
  });

  factory UserModel.fromJson(String json) =>
      UserModel.fromMap(jsonDecode(json) as DataMap);

  UserModel copyWith({
    int? id,
    String? name,
    String? avatar,
    DateTime? createdAt,
  }) =>
      UserModel(
        id: id ?? super.id,
        name: name ?? super.name,
        avatar: avatar ?? super.avatar,
        createdAt: createdAt ?? super.createdAt,
      );

  UserModel.fromMap(DataMap map)
      : this(
          id: int.parse(map['id']),
          name: map['name'] as String,
          avatar: map['avatar'] as String,
          createdAt: DateTime.parse(map['createdAt']),
        );

  DataMap toMap() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'createdAt': createdAt.toIso8601String(),
      };

  String toJson() => jsonEncode(toMap());
}
