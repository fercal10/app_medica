import 'package:app_medica/controller/paciente_controller.dart';
import 'package:app_medica/models/pacientes.dart';
import 'package:app_medica/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PacientesDetalles extends StatelessWidget {
  const PacientesDetalles({super.key, required this.idPaciente});
  final int idPaciente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PacienteController>(builder: (pacientC) {
        final Paciente info = pacientC.getByIdPaciente(idPaciente) ??
            Paciente(
                nombre: '',
                apellido: '',
                cedula: 0,
                telefono: '',
                direccion: '',
                fechaNacimiento: DateTime.now(),
                sexo: '',
                ocupacion: '');

        final height = MediaQuery.of(context).size.height;
        final dif = DateTime.now().difference(info.fechaNacimiento);
        final edad = (dif.inDays / 365.25).floor();

        // ignore: unnecessary_null_comparison

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Get.toNamed(RouterHelper.getAddPaciente(pacId: info.id.toString()));
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      pacientC.removerPaciente(idPaciente);
                      Get.back();
                    },
                    icon: const Icon(Icons.delete)),
              ],
              floating: true,
              expandedHeight: height * 0.2,
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: true,
                title: CircleAvatar(
                  maxRadius: 30,
                  child: Icon(Icons.person, size: 40),
                ),
              ),
              backgroundColor: Colors.green.shade400,
            ),
            SliverFillRemaining(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemDetalles(dato: "Nombre", info: info.nombre),
                ItemDetalles(dato: "Apellido", info: info.apellido),
                ItemDetalles(dato: "Edad", info: "$edad"),

                ItemDetalles(dato: "Cedula", info: "${info.cedula}"),
                ItemDetalles(dato: "Telefono", info: info.telefono),
                ItemDetalles(dato: "Direccion", info: info.direccion),
                ItemDetalles(dato: "Sexo", info: info.sexo),
                ItemDetalles(dato: "Ocupacion ", info: info.ocupacion),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text("Consultas :", style: TextStyle(fontSize: 24)),
                ),
                const Divider(color: Colors.blue, thickness: 3),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: info.consultas.length,
                      itemBuilder: (context, index) {
                        final consul = info.consultas[0];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () => Get.toNamed(RouterHelper.getDetallesConsulta(consul.id.toString())),
                            style: ListTileStyle.list,
                            title: Text(" Motivo ${consul.motivo}", style: const TextStyle(fontSize: 20)),
                            subtitle: Text(" Fecha ${consul.fecha?.day}/${consul.fecha?.month}/${consul.fecha?.year}",
                                style: const TextStyle(fontSize: 15)),
                            trailing: const Icon(Icons.remove_red_eye),
                          ),
                        );
                      }),
                )
              ],
            ))
          ],
        );
      }),
    );
  }
}

class ItemDetalles extends StatelessWidget {
  const ItemDetalles({
    super.key,
    required this.info,
    required this.dato,
  });

  final String dato;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          Text(
            "$dato: $info ",
            style: const TextStyle(
              fontSize: 20,
              overflow: TextOverflow.clip,
            ),
            softWrap: false,
          ),
        ],
      ),
    );
  }
}
