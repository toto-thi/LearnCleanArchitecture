import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasource/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/features/number_trivia/domain/repository/number_trivia_repository.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandom();

class NumberTriviaRepositoryImpl implements NumbertTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getNumberTrivia(int number) async {
    return await _getTrivia(() => remoteDataSource.getNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

//use typedef to declare a function name nice
  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandom getNumberOrRandom) async {
    if (await networkInfo.isConnected()) {
      try {
        final remoteTrivia = await getNumberOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
