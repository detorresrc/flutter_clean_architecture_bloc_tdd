import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utility/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers implements Usecase<List<User>, NoParams> {
  final AuthenticationRepository authRepository;

  const GetUsers({required this.authRepository});

  @override
  ResultFuture<List<User>> call(NoParams params) async => authRepository.getUsers();
}