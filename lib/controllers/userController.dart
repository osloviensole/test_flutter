import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../api/constant_api.dart';
import '../api/result_api.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserController {


  static login(String username, String password) async {
    log("# userController < login : start");

    final Dio dio = Dio();
    final base_url = "${ConstantApi.baseApi}/users/login";

    ResultApi resultApi = ResultApi();

    Map<String, dynamic> payload = {
      "telephone": username,
      "password": password
    };

    try {
      final response = await dio.post(base_url, data: payload);
      log("# userController < login < response api :${response.data}");

      UserService.token = response.data["token"];

      UserService.loggedUser = User.fromJson(response.data['user']);

      resultApi.data = "Utilisateur connecté";
      resultApi.code = response.statusCode!;

    } on DioException catch (e) {
      resultApi.data = e.response?.data['message'] ?? 'Erreur de connexion';
    } catch (e) {
      resultApi.data = 'Erreur inattendue : $e';
    }
    return resultApi;
  }

  static logout(BuildContext context) async{
    UserService.token = "";


    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (Route<dynamic> route) => false,
    );
  }

}
