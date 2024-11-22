import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDatasource extends Mock
    implements AuthenticationRemoteDatasource {}

void main() {
  late MockAuthRemoteDatasource remoteDatasource;
  late AuthenticationRepositoryImplementation repository;

  setUp(() {
    remoteDatasource = MockAuthRemoteDatasource();
    repository = AuthenticationRepositoryImplementation(remoteDatasource);
  });

  group('createUser', () {
    test(
        'it should call the remote [AuthenticationRemoteDatasource.createUser] and complete successfully when the call to the remote datasource is successfull',
        () async {
      // Arrange
      when(() => remoteDatasource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenAnswer((_) async => Future.value(null));

      const createdAt = '2021-09-01';
      const name = 'John Doe';
      const avatar = 'https://avatar.com';

      // Act
      final result = await repository.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      // Assert
      expect(result, const Right(null));
      verify(() => remoteDatasource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return a [ApiFailure] when the call to remote datasource is unsuccessfull',
        () async {
      // Arrange
      const tException = ApiException(
          message: "Unknown Error Occurred",
          statusCode: 500,
        );

      when(() => remoteDatasource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenThrow(tException);

      const createdAt = '2021-09-01';
      const name = 'John Doe';
      const avatar = 'https://avatar.com';

      // Act
      final result = await repository.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      // Assert
      expect(
        result,
        equals(
          Left(
            ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
    });

    test(
        'should return a [ServerFailure] when the call to remote datasource is unsuccessfull',
        () async {
      // Arrange
      final tException = Exception('Unknown Error Occurred');

      when(() => remoteDatasource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenThrow(tException);

      const createdAt = '2021-09-01';
      const name = 'John Doe';
      const avatar = 'https://avatar.com';

      // Act
      final result = await repository.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      // Assert
      expect(
        result,
        equals(
          Left(
            ServerFailure(
              message: tException.toString(),
              statusCode: 500,
            ),
          ),
        ),
      );
    });
  });

  group('getUsers', () {
    test('it should call the remote [RemoteDatasource.createUser] and return [List<User>]', () async {
      // Arrange
      final users = [
        UserModel(
          id: 1,
          createdAt: DateTime.parse('2021-09-01'),
          name: 'John Doe #1',
          avatar: 'https://avatar.com',
        ),
        UserModel(
          id: 2,
          createdAt: DateTime.parse('2021-09-01'),
          name: 'Jane Doe #2',
          avatar: 'https://avatar.com',
        ),
      ];

       when(() => remoteDatasource.getUsers())
      .thenAnswer((_) async => users);

      // Act
      final result = await repository.getUsers();
      final usersFromResult = result.getOrElse(() => []);  
    
      // Assert
      expect(result, isA<Right<dynamic, List<User>>>());
      expect(usersFromResult.length, equals(users.length));
      verify(() => remoteDatasource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('should return a [ApiFailure] when the call to remote datasource is unsuccessfull', () async {
      // Arrange
      const tException = ApiException(
          message: "Unknown Error Occurred",
          statusCode: 500,
        );

      when(() => remoteDatasource.getUsers())
      .thenThrow(tException);

      // Act
      final result = await repository.getUsers();
    
      // Assert
      expect(
        result,
        equals(
          Left(
            ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
    });

    test(
        'should return a [ServerFailure] when the call to remote datasource is unsuccessfull',
        () async {
      // Arrange
      final tException = Exception('Unknown Error Occurred');

      when(() => remoteDatasource.getUsers()).thenThrow(tException);

      // Act
      final result = await repository.getUsers();

      // Assert
      expect(
        result,
        equals(
          Left(
            ServerFailure(
              message: tException.toString(),
              statusCode: 500,
            ),
          ),
        ),
      );
    });
  });
}
