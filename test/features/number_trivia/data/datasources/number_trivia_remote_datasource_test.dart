import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSource dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSource(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia'), 200));
  }

  void setUpMockHttpClientError() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Not found', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia')));

    test(
      'should perform a GET request on a URL with number being the endpoint and with "application/json" header',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        dataSource.getConcreteNumberTrivia(tNumber);

        // assert
        verify(mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response status code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return ServerException when the response status code is a error code',
      () async {
        // arrange
        setUpMockHttpClientError();

        // act
        final call = dataSource.getConcreteNumberTrivia;

        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia')));

    test(
      'should perform a GET request on a URL with number being the endpoint and with "application/json" header',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        dataSource.getRandomNumberTrivia();

        // assert
        verify(mockHttpClient.get(
          Uri.parse('http://numbersapi.com/random'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response status code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        final result = await dataSource.getRandomNumberTrivia();

        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return ServerException when the response status code is a error code',
      () async {
        // arrange
        setUpMockHttpClientError();

        // act
        final call = dataSource.getRandomNumberTrivia;

        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
