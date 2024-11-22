import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/usecases/get_users.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CreateUser _createUser;
  final GetUsers _getUsers;

  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {});

    on<CreateUserEvent>(_createUserHandler);

    on<GetUsersEvent>(_getUsersHandler);
  }

  FutureOr<void> _createUserHandler(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const CreatingUserState());

    final response = await _createUser(CreateUserParams(
      name: event.name,
      avatar: event.name,
      createdAt: event.createdAt,
    ));

    response.fold(
      (failure) => emit(
        AuthenticationError(failure.errorMessage),
      ),
      (_) => emit(const UserCreatedState()),
    );
  }

  FutureOr<void> _getUsersHandler(
      GetUsersEvent event, Emitter<AuthenticationState> emit) async {
    emit(const GettingUsersState());

    final response = await _getUsers(NoParams());
    response.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (users) => emit(UsersLoadedState(users)),
    );
  }
}
