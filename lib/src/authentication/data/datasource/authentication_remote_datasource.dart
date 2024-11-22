import 'dart:convert';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utility/constants.dart';
import 'package:tdd_tutorial/core/utility/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDatasource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

class AuthenticationRemoteDatasourceImpl
    implements AuthenticationRemoteDatasource {
  final http.Client client;

  const AuthenticationRemoteDatasourceImpl(this.client);

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    final uri = Uri.parse("$apiBaseUrl/users");

    try {
      final response = await client.post(
        uri,
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          'avatar': avatar,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (!(response.statusCode == 201 || response.statusCode == 200)) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final uri = Uri.parse("$apiBaseUrl/users");

    try{
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        return List<DataMap>.from(jsonDecode(response.body) as List)
            .map((userData) => UserModel.fromMap(userData))
            .toList();
      }
      throw ApiException(message: response.body, statusCode: response.statusCode);
    }on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }
}
