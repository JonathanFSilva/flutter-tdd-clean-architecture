import 'dart:convert';

import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: 'Test text.', number: 1);

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is a integer',
      () {
        // act
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () {
        // act
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () {
        // act
        final expectedResult = {'text': 'Test text.', 'number': 1};

        final result = tNumberTriviaModel.toJson();

        // assert
        expect(result, expectedResult);
      },
    );
  });
}
