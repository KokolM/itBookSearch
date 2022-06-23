import 'dart:io';

class HolupHttpException extends HttpException {
  final int statusCode;

  static _resolveException(int statusCode) {
    switch (statusCode) {
      case HttpStatus.badRequest:
        return 'Bad Request';
      case HttpStatus.unauthorized:
        return 'Unauthorized';
      case HttpStatus.forbidden:
        return 'Forbidden';
      case HttpStatus.notFound:
        return 'Not Found';
      case HttpStatus.methodNotAllowed:
        return 'Method Not Allowed';
      case HttpStatus.conflict:
        return 'Conflict';
      case HttpStatus.internalServerError:
        return 'Internal Server Error';
      case HttpStatus.notImplemented:
        return 'Not Implemented';
      case HttpStatus.serviceUnavailable:
        return 'Service Unavailable';
      default:
        return 'Http Exception';
    }
  }

  HolupHttpException(Uri uri, this.statusCode, [String? message])
      : super(message ?? _resolveException(statusCode), uri: uri);

  @override
  String toString() => '$statusCode $message:\n${uri?.authority ?? ''}${uri?.path ?? ''}';
}

class StatusCodeException extends HolupHttpException {
  StatusCodeException(Uri uri, int statusCode, int expectedStatusCode)
      : super(
          uri,
          statusCode,
          'Unexpected status code. Expected was: $expectedStatusCode',
        );
}
