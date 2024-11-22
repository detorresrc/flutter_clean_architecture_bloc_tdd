import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';

typedef DataMap = Map<String, dynamic>;
typedef ResultFuture<TRight> = Future<Either<Failure, TRight>>;
typedef ResultVoid = Future<Either<Failure, void>>;