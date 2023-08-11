import 'package:app_medica/models/pacientes.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Cita {
  int id = 0;
  String comentario;

  final paciente = ToOne<Paciente>();

  @Property(type: PropertyType.dateNano)
  DateTime? fecha;

  Cita({required this.fecha, required this.comentario});
}
