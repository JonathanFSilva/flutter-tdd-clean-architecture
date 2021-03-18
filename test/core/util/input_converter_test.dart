import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        final str = '123';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Right(123));
      },
    );

    test(
      'should return a Failure when the string is null',
      () async {
        // arrange
        final str = null;

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return InvalidInputFailure when the string is not an integer',
      () async {
        // arrange
        final str = 'a1.0';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return InvalidInputFailure when the string is a negative integer',
      () async {
        // arrange
        final str = '-123';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}