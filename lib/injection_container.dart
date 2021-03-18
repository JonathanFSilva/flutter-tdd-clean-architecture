import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/i_number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  // Features - Number Trivia
  // bloc
  serviceLocator.registerFactory<NumberTriviaBloc>(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // usecases
  serviceLocator
      .registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  //repositories
  serviceLocator.registerLazySingleton<INumberTriviaRepository>(
    () => NumberTriviaRepository(
      networkInfo: serviceLocator(),
      localDataSource: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );

  // datasources
  serviceLocator.registerLazySingleton<INumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<INumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSource(sharedPreferences: serviceLocator()));

  // Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator
      .registerLazySingleton<INetworkInfo>(() => NetworkInfo(serviceLocator()));

  // External
  SharedPreferences preferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => preferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
