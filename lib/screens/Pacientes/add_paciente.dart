import 'package:app_medica/controller/paciente_controller.dart';
import 'package:app_medica/models/pacientes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddPacientes extends StatefulWidget {
  const AddPacientes({
    super.key,
    required this.pacienteId,
  });
  final int pacienteId;

  @override
  State<AddPacientes> createState() => _AddPacientesState();
}

class _AddPacientesState extends State<AddPacientes> {
  final p = Get.find<PacienteController>();

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final fechaController = TextEditingController();
  final ocupacionController = TextEditingController();
  DateTime? fechaNacimiento;

  final nombrefocus = FocusNode();
  final apellidofocus = FocusNode();
  final cedulafocus = FocusNode();
  final telefonofocus = FocusNode();
  final direccionfocus = FocusNode();
  final fechafocus = FocusNode();
  final ocupacionfocus = FocusNode();
  final sexofocus = FocusNode();

  static final sexos = [
    'Hombre',
    'Mujer',
  ];

  String sexo = sexos[0];
  final List<DropdownMenuItem<String>> _menuItems = sexos
      .map((String value) =>
          DropdownMenuItem<String>(value: value, child: Text(value)))
      .toList();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      /// crear objeoto paciente
      Paciente newPaciente = Paciente(
          nombre: nombreController.text.trim(),
          apellido: apellidoController.text.trim(),
          cedula: int.parse(cedulaController.text.trim()),

          telefono: telefonoController.text.trim(),
          direccion: direccionController.text.trim(),
          fechaNacimiento: fechaNacimiento ?? DateTime.now(),
          sexo: sexo,
          ocupacion: ocupacionController.text.trim());
      newPaciente.id = widget.pacienteId;
      p.agregarPacientes(newPaciente);
      Get.back();
    }
  }

  @override
  void initState() {
    if (widget.pacienteId != 0) {
      final Paciente? pacienteUp = p.getByIdPaciente(widget.pacienteId);
      if (pacienteUp != null) {
        nombreController.text = pacienteUp.nombre;
        apellidoController.text = pacienteUp.apellido;
        cedulaController.text = pacienteUp.cedula.toString();
        telefonoController.text = pacienteUp.telefono;
        direccionController.text = pacienteUp.direccion;
        ocupacionController.text = pacienteUp.ocupacion;
        pacienteUp.sexo == sexos[0] ? sexo = sexos[0] : sexo = sexos[1];
        fechaController.text =
            DateFormat('dd-MM-yyyy').format(pacienteUp.fechaNacimiento);
        fechaNacimiento = pacienteUp.fechaNacimiento;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    cedulaController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    fechaController.dispose();
    ocupacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        title: const Text(
          "Agregar Paciente ",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Nombre
              TextFormField(
                keyboardType: TextInputType.text,

                controller: nombreController,
                decoration: const InputDecoration(
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(Icons.person),
                  labelText: "Nombre ",
                ),
                onEditingComplete: () => requestFocus(context, apellidofocus),
                focusNode: nombrefocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Nombre requerido ";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              //Apellido
              TextFormField(
                keyboardType: TextInputType.text,
                controller: apellidoController,
                decoration: const InputDecoration(
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  labelText: "Apellido ",
                ),
                onEditingComplete: () => requestFocus(context, cedulafocus),
                focusNode: apellidofocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Apellido requerido ";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              //Cedula
              TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: cedulaController,
                decoration: const InputDecoration(
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(
                    Icons.credit_card,
                  ),
                  labelText: "Cedula ",
                ),
                onEditingComplete: () => requestFocus(context, telefonofocus),
                focusNode: cedulafocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Cedula requerido ";
                  }
                  if (value.trim().length < 6) {
                    return "La cedula es muy corta minimo de 6 digitos ";
                  }
                  return null;
                },
              ),
              //Telefono
              const SizedBox(
                height: 20,
              ),
              //Telefono
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: telefonoController,
                decoration: const InputDecoration(
                  prefixText: '+58 ',
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(
                    Icons.phone,
                  ),
                  labelText: "Telefono ",
                ),
                onEditingComplete: () => requestFocus(context, direccionfocus),
                focusNode: telefonofocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Numero de Telefono requerido ";
                  }
                  if (value.trim().length < 10) {
                    return "El numero es muy corto formato 0412-XXX-XXXX ";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              //Direccion

              TextFormField(
                controller: direccionController,
                decoration: const InputDecoration(
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(
                    Icons.directions,
                  ),
                  labelText: "Direccion ",
                ),
                onEditingComplete: () => requestFocus(context, ocupacionfocus),
                focusNode: direccionfocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Direccion  requerido ";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              //ocupacion
              TextFormField(
                keyboardType: TextInputType.text,
                controller: ocupacionController,
                decoration: const InputDecoration(
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(
                    Icons.apartment,
                  ),
                  labelText: "Ocupacion ",
                ),
                onEditingComplete: () => requestFocus(context, sexofocus),
                focusNode: ocupacionfocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Ocupacion requerido ";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              //sexo
              DropdownButtonFormField(
                focusNode: sexofocus,
                decoration: InputDecoration(
                  hoverColor: Colors.blue,
                  border: const OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon((sexo == sexos[0]) ? Icons.man : Icons.woman),
                  labelText: "Sexo ",
                ),
                items: _menuItems,
                value: sexo,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      sexo = newValue;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              //Fechas de nacimiento
              TextFormField(
                controller: fechaController,
                decoration: const InputDecoration(
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(Icons.calendar_month_outlined),
                  labelText: "Fecha de nacimiento   ",
                ),
                readOnly: true,
                validator: (value) {
                  if (fechaNacimiento == null) {
                    return "Fecha de Nacimietno requeridad ";
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1913),
                      lastDate: DateTime.now());
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    setState(() {
                      fechaController.text = formattedDate;
                      fechaNacimiento = pickedDate;
                    });
                  }
                },
              ),

              const SizedBox(
                height: 40,
              ),
              //Boton de enviar
              ElevatedButton(
                onPressed: () => _onSave(),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.save,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Guardar'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void requestFocus(BuildContext context, FocusNode focusNode) {
  FocusScope.of(context).requestFocus(focusNode);
}
