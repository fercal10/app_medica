import 'package:app_medica/models/consulta.dart';
import 'package:app_medica/objectbox.g.dart';
import 'package:get/get.dart';

class ConsultaController extends GetxController {
  final Store store;
  late final Box<Consulta> _consultaBox;
  final consultas = <Consulta>[];

  ConsultaController({required this.store});

  @override
  void onInit() {
    getConsultas();
    super.onInit();
  }

  @override
  void dispose() {
    store.close();
    super.dispose();
  }

  void getConsultas() {
    _consultaBox = store.box<Consulta>();
    loadConsultas();
  }

  Consulta? getConsultaById(int id) {
    return _consultaBox.get(id);
  }

  void loadConsultas() {
    consultas.clear();
    consultas.addAll(_consultaBox.getAll());
    update();
  }

  int agregarConsulta(Consulta newConsulta) {
    int id = _consultaBox.put(newConsulta);
    loadConsultas();
    return id;
  }

  void removerall() {
    _consultaBox.removeAll();
    loadConsultas();
  }

  void removerConsulta(int id) {
    _consultaBox.remove(id);
    loadConsultas();
  }

  void removerConsultasPaciente(List<int> listaId) {
    _consultaBox.removeMany(listaId);
    loadConsultas();
  }
}
