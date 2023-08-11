import 'package:app_medica/models/cita.dart';
import 'package:app_medica/models/consulta.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Paciente {
  int id = 0;
  String nombre;
  String apellido;
  String telefono;
  String direccion;
  String sexo;
  String ocupacion;
  int cedula;

  @Backlink()
  final consultas = ToMany<Consulta>();

  @Backlink()
  final citas = ToMany<Cita>();

  @Property(type: PropertyType.dateNano)
  DateTime fechaNacimiento;

  Paciente({
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.telefono,
    required this.direccion,
    required this.fechaNacimiento,
    required this.sexo,
    required this.ocupacion,
  });
}
