import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/usecases/get_users.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final CreateUser _createUser;
  final GetUsers _getUsers;

  AuthenticationCubit({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthenticationInitial());

  Future<void> createUser({
    required String name,
    required String avatar,
    required String createdAt,
  }) async {
    emit(const CreatingUserState());

    final response = await _createUser(CreateUserParams(
      name: name,
      avatar: avatar,
      createdAt: createdAt,
    ));

    response.fold(
      (failure) => emit(
        AuthenticationErrorState(failure.errorMessage),
      ),
      (_) => emit(const UserCreatedState()),
    );
  }

  Future<void> getUsers() async {
    emit(const GettingUsersState());

    final response = await _getUsers(NoParams());
    response.fold(
      (failure) => emit(AuthenticationErrorState(failure.errorMessage)),
      (users) => emit(UsersLoadedState(users)),
    );
  }
}
