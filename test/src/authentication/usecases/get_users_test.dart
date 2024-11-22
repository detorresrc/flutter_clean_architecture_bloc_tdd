import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/usecases/get_users.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;

  final tResponse = [
    User(
      id: 1,
      name: 'John Doe',
      avatar: 'https://avatar.com',
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsers(authRepository: repository);
  });

  test(
      'should call the [AuthenticationRepository.getUsers] ad return [List<User>]',
      () async {
    // Arrange
    when(
      () => repository.getUsers(),
    ).thenAnswer(
      (_) async => Right(tResponse),
    );
    // Act
    final result = await usecase(NoParams());
    // Assert
    expect(
      result,
      equals(
        Right<dynamic, List<User>>(tResponse),
      ),
    );
    verify(() => repository.getUsers()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
