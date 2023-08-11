import 'package:app_medica/controller/consultas_controller.dart';
import 'package:app_medica/controller/paciente_controller.dart';
import 'package:app_medica/models/consulta.dart';
import 'package:app_medica/models/pacientes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddConsulta extends StatefulWidget {
  const AddConsulta({
    super.key,
    this.consultaId = 0,
  });
  final int consultaId;

  @override
  State<AddConsulta> createState() => _AddConsultaState();
}

class _AddConsultaState extends State<AddConsulta> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final pacController = TextEditingController();
  final motivoController = TextEditingController();
  final enfermedadController = TextEditingController();
  final diagnosticoController = TextEditingController();
  final estudioController = TextEditingController();

  final List<TextEditingController> _controllers = [];
  final List<TextField> _fields = [];

  final motivofocus = FocusNode();
  final enfermedadfocus = FocusNode();
  final diagnosticodadfocus = FocusNode();
  final estudiofocus = FocusNode();

  final pacienteC = Get.find<PacienteController>();
  final consultaC = Get.find<ConsultaController>();

  // ignore: avoid_init_to_null
  Paciente? paciente = null;

  static String _displayStringForOption(Paciente option) => "${option.nombre} ${option.apellido}";

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final tratamiento = <String>[];
      for (final controller in _controllers) {
        tratamiento.add(controller.text);
      }

      /// crear objeoto paciente
      Consulta newConsulta = Consulta(
          motivo: motivoController.text.trim(),
          efermedadActual: enfermedadController.text.trim(),
          diganostico: diagnosticoController.text.trim(),
          fecha: DateTime.now(),
          tratamiento: tratamiento,
          indicaciones: estudioController.text.trim());
      //Agregamos el Paciente

      newConsulta.paciente.target = paciente;
      newConsulta.id = widget.consultaId;
      consultaC.agregarConsulta(newConsulta);

      Get.back();
    }
  }

  void agregarTratamiento() {
    final controller = TextEditingController();
    final field = TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: "Medicamento ${_controllers.length + 1}",
        ));
    setState(() {
      _controllers.add(controller);
      _fields.add(field);
    });
  }

  @override
  void initState() {
    if (widget.consultaId != 0) {
      final Consulta? consultaUp = consultaC.getConsultaById(widget.consultaId);
      if (consultaUp != null) {
        paciente = consultaUp.paciente.target;
        pacController.text = "${consultaUp.paciente.target!.nombre} ${consultaUp.paciente.target!.apellido}";
        motivoController.text = consultaUp.motivo;
        enfermedadController.text = consultaUp.efermedadActual;
        diagnosticoController.text = consultaUp.diganostico;
        estudioController.text = consultaUp.indicaciones;

        consultaUp.tratamiento.asMap().forEach((key, value) {
          agregarTratamiento();
          _controllers[key].text = value;
        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    motivoController.dispose();
    enfermedadController.dispose();
    diagnosticoController.dispose();
    estudioController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        title: const Text(
          "Agregar Consulta ",
        ),
      ),
      body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Paciente
                Autocomplete<Paciente>(
                  initialValue: pacController.value,
                  optionsMaxHeight: 200,
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      autofocus: true,
                      onEditingComplete: () => requestFocus(context, motivofocus),
                      readOnly: widget.consultaId != 0,
                      focusNode: focusNode,
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        hoverColor: Colors.blue,
                        border: OutlineInputBorder(gapPadding: 6),
                        filled: true,
                        icon: Icon(Icons.person),
                        labelText: "Paciente  ",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (textEditingController.text.isEmpty) return "Paciente no selecionado";
                        if (paciente == null) return "Paciente existente ,Agrega el Paciente primero";
                        return null;
                      },
                    );
                  },
                  displayStringForOption: _displayStringForOption,
                  optionsBuilder: (textEditingValue) {
                    final sugerencias = pacienteC.pacientes;

                    if (textEditingValue.text == '') {
                      return const Iterable<Paciente>.empty();
                    }
                    return sugerencias.where((p) {
                      return p.nombre.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                          p.apellido.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (option) {
                    final newpaciente = pacienteC.getByIdPaciente(option.id)!;

                    paciente = newpaciente;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),
                //Motivo
                TextFormField(
                  controller: motivoController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hoverColor: Colors.blue,
                    border: OutlineInputBorder(gapPadding: 6),
                    filled: true,
                    icon: Icon(Icons.vaccines_rounded),
                    labelText: "Motivo de consulta  ",
                  ),
                  onEditingComplete: () => requestFocus(context, enfermedadfocus),
                  focusNode: motivofocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) return " Motivo requerido ";
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                //Emfermedad actual
                TextFormField(
                  controller: enfermedadController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hoverColor: Colors.blue,
                    border: OutlineInputBorder(gapPadding: 6),
                    filled: true,
                    icon: Icon(
                      Icons.people,
                      color: Colors.white,
                    ),
                    labelText: "Enfermedad actual ",
                  ),
                  onEditingComplete: () => requestFocus(context, diagnosticodadfocus),
                  focusNode: enfermedadfocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) return " Emfermedad requerido ";
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                //Dignotico
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: diagnosticoController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hoverColor: Colors.blue,
                    border: OutlineInputBorder(gapPadding: 6),
                    filled: true,
                    icon: Icon(
                      Icons.person_search,
                    ),
                    labelText: "Diagnostico ",
                  ),
                  onEditingComplete: () => requestFocus(context, estudiofocus),
                  focusNode: diagnosticodadfocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) return " Diagnostico requerido ";
                    return null;
                  },
                ),

                const SizedBox(
                  height: 10,
                ),
                //Tratamiento
                Column(
                  children: [
                    ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Agregar Medicamento"),
                          const SizedBox(
                            width: 24,
                          ),
                          IconButton(
                              icon: const Icon(Icons.add),
                              iconSize: 24,
                              color: Colors.black,
                              onPressed: agregarTratamiento),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            iconSize: 24,
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _controllers.removeLast();
                                _fields.removeLast();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _fields.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: _fields[index],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //Indicaciones
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  controller: estudioController,
                  decoration: const InputDecoration(
                    hoverColor: Colors.blue,
                    border: OutlineInputBorder(gapPadding: 6),
                    filled: true,
                    icon: Icon(
                      Icons.medical_information,
                    ),
                    labelText: "Indicaciones ",
                  ),
                  // onEditingComplete: () => requestFocus(context, ocupacionfocus),
                  // focusNode: telefonofocus,
                  validator: (value) {
                    if (value!.isEmpty) return "Indicaciones necesarias";
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                //Boton de enviar
                ElevatedButton(
                  onPressed: _onSave,
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
          )),
    );
  }
}

void requestFocus(BuildContext context, FocusNode focusNode) {
  FocusScope.of(context).requestFocus(focusNode);
}
