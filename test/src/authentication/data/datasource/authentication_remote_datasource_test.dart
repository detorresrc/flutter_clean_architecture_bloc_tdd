import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utility/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasource/authentication_remote_datasource.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late AuthenticationRemoteDatasourceImpl remoteDatasource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDatasource = AuthenticationRemoteDatasourceImpl(mockHttpClient);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('should complete successfully when the status code is 200 or 201',
        () async {
      // arrange
      when(
        () => mockHttpClient.post(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
          (_) async => http.Response('User created successfully', 201));

      const createdAt = '2021-09-01';
      const name = 'John Doe';
      const avatar = 'https://avatar.com/johndoe.png';

      // act
      // This is how to test method returns void
      final method = remoteDatasource.createUser;

      // assert
      expect(
          method(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
          completes);
      verify(
        () => mockHttpClient.post(
          Uri.parse("$apiBaseUrl/users"),
          body: jsonEncode(
            {
              'createdAt': createdAt,
              'name': name,
              'avatar': avatar,
            },
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test('should throw [APIException] when the status code is not 200 or 201',
        () async {
      // arrange
      when(
        () => mockHttpClient.post(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('Body: Error Message', 400));

      // act
      final method = remoteDatasource.createUser;

      // assert
      expect(
        () => method(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.message, 'message', 'Body: Error Message')
              .having((e) => e.statusCode, 'statusCode', 400),
        ),
      );
      verify(
        () => mockHttpClient.post(
          Uri.parse("$apiBaseUrl/users"),
          body: jsonEncode(
            {
              'createdAt': 'createdAt',
              'name': 'name',
              'avatar': 'avatar',
            },
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test(
        'should throw [APIException with statusCode 505] when the unknown api error has occured.',
        () async {
      // arrange
      when(
        () => mockHttpClient.post(
          any(),
          body: any(named: 'body'),
        ),
      ).thenThrow(Exception("An error has occured!"));

      // act
      final method = remoteDatasource.createUser;

      // assert
      expect(
        () => method(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.message, 'message',
                  'Exception: An error has occured!')
              .having((e) => e.statusCode, 'statusCode', 505),
        ),
      );
      verify(
        () => mockHttpClient.post(
          Uri.parse("$apiBaseUrl/users"),
          body: jsonEncode(
            {
              'createdAt': 'createdAt',
              'name': 'name',
              'avatar': 'avatar',
            },
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });

  group('getUsers', () {
    final tUsers = [
      {
        "createdAt": "2024-10-11T10:07:41.423Z",
        "name": "Lionel Prohaska",
        "avatar":
            "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/884.jpg",
        "id": 1
      },
      {
        "createdAt": "2024-10-11T05:30:46.499Z",
        "name": "Steve Harber",
        "avatar":
            "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/4.jpg",
        "id": 2
      },
      {
        "createdAt": "2024-10-15T08:08:24.195Z",
        "name": "Peter Wehner",
        "avatar":
            "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1093.jpg",
        "id": 3
      }
    ];

    test(
        'should return [List<UserModel>] when the response status code is 200 ',
        () async {
      // arrange
      when(
        () => mockHttpClient.get(
          any(),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode(tUsers),
          200,
        ),
      );

      // act
      final response = await remoteDatasource.getUsers();

      // assert
      expect(response, isA<List<UserModel>>());
      expect(response.first.name, "Lionel Prohaska");
      expect(response.length, 3);
      verify(
        () => mockHttpClient.get(Uri.parse("$apiBaseUrl/users")),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test('should throw [APIException] when the status code is not 200',
        () async {
      // arrange
      when(
        () => mockHttpClient.get(
          any(),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          'Server Error!',
          500,
        ),
      );

      // act
      final method = remoteDatasource.getUsers;

      // assert
      expect(
        () => method(),
        throwsA(
          isA<ApiException>()
            .having((e) => e.message, 'message', 'Server Error!')
            .having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    test('should throw [APIException] when the httpClient throws an error',
        () async {
      // arrange
      when(
        () => mockHttpClient.get(
          any(),
        ),
      ).thenThrow(Exception("An error has occured!"));

      // act
      final method = remoteDatasource.getUsers;

      // assert
      expect(
        () => method(),
        throwsA(
          isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 505),
        ),
      );
    });
  });
}
