import 'package:tdd_tutorial/core/utility/typedef.dart';

abstract class Usecase<Type, Params> {
  ResultFuture<Type> call(Params params);
}

class NoParams{}