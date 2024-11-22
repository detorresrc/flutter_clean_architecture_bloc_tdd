import 'package:get_it/get_it.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tdd_tutorial/src/authentication/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/usecases/get_users.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => AuthenticationCubit(
      createUser: sl(),
      getUsers: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateUser(authRepository: sl()));
  sl.registerLazySingleton(() => GetUsers(authRepository: sl()));
  sl.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImplementation(sl()));
  sl.registerLazySingleton<AuthenticationRemoteDatasource>(() => AuthenticationRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<http.Client>(http.Client.new, dispose: (client) => client.close());  
}
