import 'package:app_medica/controller/consultas_controller.dart';
import 'package:app_medica/models/pacientes.dart';
import 'package:app_medica/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PacienteController extends GetxController {
  final Store store;
  late final Box<Paciente> _pacienteBox;
  final pacientes = <Paciente>[].obs;

  PacienteController({required this.store});

  @override
  void onInit() {
    getPacientes();
    super.onInit();
  }

  @override
  void dispose() {
    store.close();
    super.dispose();
  }

  void _loadPacientes() {
    pacientes.clear();
    pacientes.addAll(_pacienteBox.getAll());
    update();
  }

  void getPacientes() {
    _pacienteBox = store.box<Paciente>();
    _loadPacientes();
  }

  Paciente? getByIdPaciente(int id) {
    return _pacienteBox.get(id);
  }

  void agregarPacientes(Paciente newPaciente) {
    _pacienteBox.put(newPaciente);
    _loadPacientes();
  }

  void removerall() {
    _pacienteBox.removeAll();
    pacientes.clear();
    update();
  }

  void removerPaciente(int id) {
    final delepaciente = _pacienteBox.get(id);
    final consultas = delepaciente?.consultas.map((element) => element.id).toList() ?? [];
    final subc = Get.find<ConsultaController>();
    subc.removerConsultasPaciente(consultas);
    _pacienteBox.remove(id);
    _loadPacientes();
  }

  Paciente? findPacienteByCedula(int cedula) {
    final query = _pacienteBox.query(Paciente_.cedula.equals(cedula)).build();
    final paciente = query.findFirst();
    query.close();

    return paciente;
  }

  map(DropdownMenuItem<String> Function(String value) param0) {}
}
