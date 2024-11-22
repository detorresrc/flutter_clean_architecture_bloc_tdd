import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utility/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class CreateUser implements Usecase<void, CreateUserParams> {
  final AuthenticationRepository authRepository;

  const CreateUser({required this.authRepository});

  @override
  ResultVoid call(CreateUserParams params) async => authRepository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      );
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  @override
  List<String> get props => [
        name,
        avatar,
        createdAt,
      ];
}
