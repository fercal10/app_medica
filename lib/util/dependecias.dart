import 'package:app_medica/controller/citas_controller.dart';
import 'package:app_medica/controller/consultas_controller.dart';
import 'package:app_medica/controller/paciente_controller.dart';
import 'package:app_medica/objectbox.g.dart';
import 'package:get/get.dart';

Future<void> init() async {
  final store = await openStore();
  Get.put(PacienteController(store: store));
  Get.put(ConsultaController(store: store));
  Get.put(CistasController(store: store));
}
