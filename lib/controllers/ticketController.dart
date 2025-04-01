import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mobile_parktax/models/ticket.dart';
import 'package:mobile_parktax/models/ticketExit.dart';

import '../api/constant_api.dart';
import '../api/result_api.dart';
import '../services/user_service.dart';

class Ticketcontroller {

  static create({required String numeroPlaque, required int heuresPrevues}) async {

    log("# Ticketcontroller < create : start");

    final Dio dio = Dio();
    final base_url = "${ConstantApi.baseApi}/tickets";

    ResultApi resultApi = ResultApi();

    Map<String, dynamic> payload = {
      "numero_plaque": numeroPlaque,
      "heures_prevues": heuresPrevues
    };


    try {
      final response = await dio.post(
        base_url,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${UserService.token}'
          },
        ),
      );

      log("# Ticketcontroller < create < response api :${response.data}");

      Ticket ticket = Ticket.fromJson(response.data['ticket']);
      String message = response.data['message'];

      resultApi.data = [ticket, message];
      resultApi.code = response.statusCode!;

    } on DioException catch (e) {
      log("# Ticketcontroller < create < DioException ");
      resultApi.data = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Erreur de connexion';
    } catch (e) {
      log("# Ticketcontroller < create < catch ");
      resultApi.data = 'Erreur inattendue : $e';
    }
    return resultApi;

  }

  static ticketExit({required String code}) async {

    log("# Ticketcontroller < ticketExit : start");

    final Dio dio = Dio();
    final base_url = "${ConstantApi.baseApi}/tickets/exit";

    ResultApi resultApi = ResultApi();

    Map<String, dynamic> payload = {
      "code": code
    };


    try {
      final response = await dio.post(
        base_url,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${UserService.token}'
          },
        ),
      );

      log("# Ticketcontroller < ticketExit < response api :${response.data}");

      TicketExit ticketExit = TicketExit.fromJson(response.data);

      resultApi.data = ticketExit;
      resultApi.code = response.statusCode!;

    } on DioException catch (e) {
      log("# Ticketcontroller < ticketExit < DioException ");
      resultApi.data = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Erreur de connexion';
    } catch (e) {
      log("# Ticketcontroller < ticketExit < catch ");
      resultApi.data = 'Erreur inattendue : $e';
    }
    return resultApi;

  }


}