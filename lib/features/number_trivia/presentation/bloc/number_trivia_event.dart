part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetConcreteTriviaNumber extends NumberTriviaEvent {
  final String numberString;
  // int get number => int.parse(numberString);

  GetConcreteTriviaNumber({required this.numberString});
}

class GetRandomTriviaNumber extends NumberTriviaEvent {}
