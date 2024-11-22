import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tdd_tutorial/src/authentication/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/usecases/get_users.dart';

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams =
      CreateUserParams(createdAt: 'createdAt', name: 'name', avatar: 'avatar');
  const tAPIFailure = ApiFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
    registerFallbackValue(NoParams());
  });

  tearDown(() => cubit.close());

  test('initial state should be [AuthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUserState, UserCreatedState] when successful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (cubit) {
        cubit.createUser(
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
          createdAt: tCreateUserParams.createdAt,
        );
      },
      expect: () => const [CreatingUserState(), UserCreatedState()],
      verify: (_) {
        verify(() => createUser(any())).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUserState, AuthenticationError] when unsuccessful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Left(tAPIFailure),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.createUser(
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
          createdAt: tCreateUserParams.createdAt,
        );
      },
      expect: () =>
          [const CreatingUserState(), AuthenticationError(tAPIFailure.errorMessage)],
      verify: (_) {
        verify(() => createUser(any())).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsersState, UsersLoadedState] when successful',
      build: () {
        when(() => getUsers(any())).thenAnswer(
          (_) async => const Right([]),
        );

        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [const GettingUsersState(), const UsersLoadedState([])],
      verify: (_) {
        verify(() => getUsers(any())).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsersState, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers(any())).thenAnswer(
          (_) async => const Left(tAPIFailure),
        );

        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [const GettingUsersState(), AuthenticationError(tAPIFailure.errorMessage)],
      verify: (_) {
        verify(() => getUsers(any())).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}
