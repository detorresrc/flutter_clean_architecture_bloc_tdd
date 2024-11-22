part of 'authentication_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();
  
  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

final class CreatingUserState extends AuthenticationState{
  const CreatingUserState();
}

final class GettingUsersState extends AuthenticationState{
  const GettingUsersState();
}

final class UserCreatedState extends AuthenticationState{
  const UserCreatedState();
}

final class UsersLoadedState extends AuthenticationState{
  const UsersLoadedState(this.users);

  final List<User> users;

  @override
  List<int> get props => users.map((user) => user.id).toList();
}

final class AuthenticationErrorState extends AuthenticationState{
  const AuthenticationErrorState(this.message);

  final String message;

  @override
  List<String> get props => [message];
}