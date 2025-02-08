import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;
  late final CookieJar _cookieJar;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _init();
  }

  Future<void> _init() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    _cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage('${appDocDir.path}/.cookies/'),
    );

    _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 5),
    ));

    _dio.interceptors.addAll([
      CookieManager(_cookieJar),
      LogInterceptor(responseBody: true),
    ]);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      '/login',
      data: {'username': username, 'password': password},
    );

    if (response.statusCode != 200) {
      throw ApiException(
        code: response.statusCode,
        message: 'Login failed',
      );
    }
  }

  Future<void> logout() async {
    final response = await _dio.post('/logout');

    if (response.statusCode != 200) {
      throw ApiException(
        code: response.statusCode,
        message: 'Login failed',
      );
    }
  }
}

class ApiException implements Exception {
  final int? code;
  final String message;

  ApiException({this.code, required this.message});

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}