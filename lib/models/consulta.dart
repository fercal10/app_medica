import 'package:app_medica/models/pacientes.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Consulta {
  int id = 0;
  String motivo;
  String efermedadActual;
  String diganostico;
  String indicaciones;
  List<String> tratamiento;

  final paciente = ToOne<Paciente>();

  @Property(type: PropertyType.dateNano)
  DateTime? fecha;

  Consulta(
      {required this.motivo,
      required this.efermedadActual,
      required this.diganostico,
      this.fecha,
      required this.indicaciones,
      required this.tratamiento});
}
