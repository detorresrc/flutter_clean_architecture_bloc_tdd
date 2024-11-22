import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utility/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tModel = UserModel(
    id: 1,
    name: 'Steve Harber',
    avatar:
        'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/4.jpg',
    createdAt: DateTime.parse("2024-10-11T05:30:46.499Z"),
  );
  final tJson = fixtures("user.json");
  final tMap = jsonDecode(tJson) as DataMap;

  test('should be a subclass of [User] entity', () {
    // Arrange

    // Act

    // Assert
    expect(tModel, isA<User>());
  });

  test('should set correct value from constructor', () {
    // Arrange
    
    // Act
    final user = UserModel(
      id: tModel.id,
      name: tModel.name,
      avatar: tModel.avatar,
      createdAt: tModel.createdAt,
    );

    // Assert
    expect(tModel.id, equals(user.id));
    expect(tModel.name, equals(user.name));
    expect(tModel.avatar, equals(user.avatar));
    expect(tModel.createdAt, equals(user.createdAt));
  });

  group('fromMap', () {
    test('shoul return a [UserModel] with right data', () {
      // Arrange

      // Act
      final result = UserModel.fromMap(tMap);

      // Assert
      expect(result, equals(tModel));
    });
  });

  group('fromjson', () {
    test('shoul return a [UserModel] with right data', () {
      // Arrange

      // Act
      final result = UserModel.fromJson(tJson);

      // Assert
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('shoul return a [Map] with right data', () {
      // Arrange

      // Act
      final result = tModel.toMap();

      // Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('shoul return a [Json] with right data', () {
      // Arrange

      // Act
      final result = tModel.toJson();

      // Assert
      expect(result, equals(tJson));
    });
  });

  group('copy With', () {
    test('shoul return a [UserModel] with right data', () {
      // Arrange

      // Act
      final now = DateTime.now();
      final result = tModel.copyWith(id: 99, name: "99", avatar: "99", createdAt: now);
      final result2 = tModel.copyWith();

      // Assert
      expect(result.name, equals("99"));
      expect(result.id, equals(99));
      expect(result.avatar, equals("99"));
      expect(result.createdAt, equals(now));

      expect(result2.name, equals(tModel.name));
      expect(result2.id, equals(tModel.id));
      expect(result2.avatar, equals(tModel.avatar));
      expect(result2.createdAt, equals(tModel.createdAt));
    });
  });
}
