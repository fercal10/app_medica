import 'package:app_medica/screens/home_screen.dart';
import 'package:app_medica/screens/Pacientes/add_paciente.dart';
import 'package:app_medica/screens/Pacientes/detalles_pacientes.dart';
import 'package:app_medica/screens/Consultas/add_consulta.dart';
import 'package:app_medica/screens/Consultas/detalles_consulta.dart';

import 'package:get/get.dart';

class RouterHelper {
  static const String _initial = "/";
  static const String _addPaciente = "/add-paciente";
  static const String _detallesPaciente = "/detalles'paciente";
  static const String _addConsulta = "/add-consulta";
  static const String _detallesConsulta = "/detalles-paciente";

  static String getInitial() => _initial;
  static String getAddPaciente({String pacId = "0"}) => "$_addPaciente?pacId=$pacId";
  static String getDetallesPaciente(String pacId) => "$_detallesPaciente?pacId=$pacId";
  static String getAddConsulta({String pacId = "0"}) => '$_addConsulta?pacId=$pacId';
  static String getDetallesConsulta(String pacId) => "$_detallesConsulta?pacId=$pacId";

  static final route = [
    GetPage(name: _initial, page: () => const HomeScreen()),
    GetPage(
        name: _addPaciente,
        page: () {
          var pacId = int.parse(Get.parameters['pacId']!);

          return AddPacientes(
            pacienteId: pacId,
          );
        }),
    GetPage(
        name: _addConsulta,
        page: () {
          var pacId = int.parse(Get.parameters['pacId']!);
          return AddConsulta(
            consultaId: pacId,
          );
        }),
    GetPage(
        name: _detallesPaciente,
        page: () {
          final int pacId = int.parse(Get.parameters['pacId']!);

          return PacientesDetalles(
            idPaciente: pacId,
          );
        }),
    GetPage(
        name: _detallesConsulta,
        page: () {
          final int pacId = int.parse(Get.parameters['pacId']!);

          return ConsultaDetalles(
            idConsulta: pacId,
          );
        }),
  ];
}
