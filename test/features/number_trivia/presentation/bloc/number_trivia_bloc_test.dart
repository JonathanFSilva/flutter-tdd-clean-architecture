import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test(
    'initialState should be Empty ',
    () async {
      // assert
      expect(bloc.state, Empty());
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(Right(tNumberParsed));
    }

    test(
      'should call the InputConverter to validade and convert the string to unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockInputConverter.stringToUnsignedInteger(tNumberString));

        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(Left(InvalidInputFailure()));

        // assert later
        final expectedOrder = [
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];

        expect(bloc.state, Empty());
        expectLater(bloc, emitsInOrder(expectedOrder));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
          mockGetConcreteNumberTrivia(
            Params(number: tNumberParsed),
          ),
        );

        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expectedOrder = [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];

        expect(bloc.state, Empty());
        expectLater(bloc, emitsInOrder(expectedOrder));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expectedOrder = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];

        expect(bloc.state, Empty());
        expectLater(bloc, emitsInOrder(expectedOrder));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expectedOrder = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];

        expect(bloc.state, Empty());
        expectLater(bloc, emitsInOrder(expectedOrder));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(NoParams()));

        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expectedOrder = [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];

        expect(bloc.state, Empty());
        expectLater(bloc, emitsInOrder(expectedOrder));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expectedOrder = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];

        expect(bloc.state, Empty());
        expectLater(bloc, emitsInOrder(expectedOrder));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expectedOrder = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];

        expect(bloc.state, Empty());
        expectLater(bloc, emitsInOrder(expectedOrder));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
