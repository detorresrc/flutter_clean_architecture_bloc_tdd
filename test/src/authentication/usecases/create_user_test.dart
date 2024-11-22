import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/usecases/create_user.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUser usecase;
  late AuthenticationRepository authRepository;
  const CreateUserParams params = CreateUserParams(
    createdAt: '2021-09-01',
    name: 'John Doe',
    avatar: 'https://avatar.com',
  );

  setUpAll(() {
    authRepository = MockAuthRepo();

    usecase = CreateUser(authRepository: authRepository);
  });

  test('should Equatable work as expected', () {
    // Arrange
    // ignore: prefer_const_constructors
    final params1 = CreateUserParams(
      createdAt: '2021-09-01',
      name: 'John Doe',
      avatar: 'https://avatar.com',
    );
    // ignore: prefer_const_constructors
    final params2 = CreateUserParams(
      createdAt: '2021-09-01',
      name: 'John Doe',
      avatar: 'https://avatar.com',
    );

    // Act
    final result = params1 == params2;

    // Assert
    expect(result, isTrue);
  });

  test('should call the [AuthenticationRepository.createUser]', () async {
    // Arrange
    when(
      () => authRepository.createUser(
        createdAt: any(named: 'createdAt'),
        name: any(named: 'name'),
        avatar: any(named: 'avatar'),
      ),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(params);

    // Assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(
      () => authRepository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      ),
    ).called(1);
    verifyNoMoreInteractions(authRepository);
  });
}
