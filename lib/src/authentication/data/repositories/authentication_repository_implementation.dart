import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/core/utility/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  final AuthenticationRemoteDatasource _remoteDatasource;

  const AuthenticationRepositoryImplementation(this._remoteDatasource);

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      await _remoteDatasource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<List<UserModel>> getUsers() async {
    try {
      return Right(
        await _remoteDatasource.getUsers(),
      );
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
