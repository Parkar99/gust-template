import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

class R {
  static final _htmlContentTypeHeader = {HttpHeaders.contentTypeHeader: ContentType.html.mimeType};
  static final _textContentTypeHeader = {HttpHeaders.contentTypeHeader: ContentType.text.mimeType};
  static final _jsonContentTypeHeader = {HttpHeaders.contentTypeHeader: ContentType.json.mimeType};

  R._();

  static Response html(
    dynamic body, {
    Map<String, /* String | List<String> */ Object>? headers,
    Encoding? encoding,
    Map<String, Object>? context,
    int statusCode = 200,
  }) {
    return Response(
      statusCode,
      body: body ?? 'OK',
      context: context,
      encoding: encoding,
      headers: (headers?..addAll(_htmlContentTypeHeader)) ?? _htmlContentTypeHeader,
    );
  }

  static Response text(
    dynamic body, {
    Map<String, /* String | List<String> */ Object>? headers,
    Encoding? encoding,
    Map<String, Object>? context,
    int statusCode = 200,
  }) {
    return Response(
      statusCode,
      body: body ?? 'OK',
      context: context,
      encoding: encoding,
      headers: (headers?..addAll(_textContentTypeHeader)) ?? _textContentTypeHeader,
    );
  }

  static Response json(
    dynamic body, {
    Map<String, /* String | List<String> */ Object>? headers,
    Encoding? encoding,
    Map<String, Object>? context,
    int statusCode = 200,
  }) {
    if ((body is! Map) && (body is! List)) throw ArgumentError('Body must be a Map or a List');

    return Response(
      statusCode,
      body: jsonEncode(body),
      context: context,
      encoding: encoding,
      headers: (headers?..addAll(_jsonContentTypeHeader)) ?? _jsonContentTypeHeader,
    );
  }
}
