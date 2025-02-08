import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:cookielab/logger.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal();

  Dio? _dio;

  Future<Dio> get dio async {
    if (_dio == null) await _init();
    return _dio!;
  }

  Future<void> _init() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    final cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage('${appDocDir.path}/.cookies/'),
    );

    final dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 5),
      validateStatus: (status) => status != null && (status >= 200 && status < 500),
    ));
    dio.interceptors.addAll([
      CookieManager(cookieJar),
      LogInterceptor(responseBody: true),
    ]);
    _dio = dio;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await (await dio).post(
      '/login',
      data: {'username': username, 'password': password},
    );

    if (response.statusCode != 200) {
      throw ApiException(
        code: response.statusCode,
        message: 'ログインに失敗しました: ${response.data['error']}',
      );
    }
  }

  Future<String> fetchHelloMessage() async {
    final response = await (await dio).get('/hello');

    if (response.statusCode != 200) {
      throw ApiException(
        code: response.statusCode,
        message: 'ハローに失敗しました: ${response.data['error']}',
      );
    }
    return response.data['message'];
  }

  Future<void> logout() async {
    final response = await (await dio).post('/logout');

    if (response.statusCode != 200) {
      throw ApiException(
        code: response.statusCode,
        message: 'ログアウトに失敗しました: ${response.data['error']}',
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