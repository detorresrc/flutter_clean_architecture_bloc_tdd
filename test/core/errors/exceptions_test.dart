import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';

void main() {
  test('should equatable works properly', (){
    // Arrange
    const exception1 = ApiException(message: 'message', statusCode: 400);
    const exception2 = ApiException(message: 'message', statusCode: 400);
    const exception3 = ApiException(message: 'message', statusCode: 200);
    // Act
    // Assert
    expect(exception1, exception2);
    expect(exception1, isNot(exception3));
  });
}