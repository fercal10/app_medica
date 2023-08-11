import 'package:app_medica/models/cita.dart';
import 'package:app_medica/objectbox.g.dart';
import 'package:get/get.dart';

class CistasController extends GetxController {
  final Store store;
  late final Box<Cita> _boxCitas;
  final citas = <Cita>[];

  CistasController({required this.store});
  @override
  void onInit() {
    getConsultas();
    super.onInit();
  }

  void getConsultas() {
    _boxCitas = store.box<Cita>();
    loadCitas();
  }

  void loadCitas() {
    citas.clear();
    citas.addAll(_boxCitas.getAll());
    update();
  }

  void agregaCita(Cita newCita) {
    _boxCitas.put(newCita);
    loadCitas();
  }

  void eliminanrCita(int citaId) {
    _boxCitas.remove(citaId);
    loadCitas();
  }
}
