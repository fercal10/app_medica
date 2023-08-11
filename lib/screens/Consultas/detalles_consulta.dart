import 'dart:typed_data';
import 'package:app_medica/controller/consultas_controller.dart';
import 'package:app_medica/models/consulta.dart';
import 'package:app_medica/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:app_medica/widget/hoja_pdf.dart';

class ConsultaDetalles extends StatelessWidget {
  const ConsultaDetalles({super.key, required this.idConsulta});
  final int idConsulta;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GetBuilder<ConsultaController>(builder: (consultaC) {
        final Consulta consulta = consultaC.getConsultaById(idConsulta) ??
            Consulta(motivo: '', efermedadActual: '', diganostico: '', indicaciones: '', tratamiento: []);
        final name = "${consulta.paciente.target!.nombre} ${consulta.paciente.target!.apellido}";
        final fecha = " ${consulta.fecha!.day}/${consulta.fecha!.month}/${consulta.fecha!.year}";

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(RouterHelper.getAddConsulta(pacId: consulta.id.toString()));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                //Eliminar
                IconButton(
                  onPressed: () {
                    consultaC.removerConsulta(consulta.id);
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                //Compartir
                IconButton(
                  onPressed: () async {
                    final Uint8List pdfShare = await generateResume(PdfPageFormat.letter, consulta);
                    await Printing.sharePdf(
                        bytes: pdfShare,
                        filename:
                            "Consulta ${consulta.paciente.target!.consultas.length}-${consulta.paciente.target!.nombre}${consulta.paciente.target!.apellido}.pdf");
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
              floating: true,
              expandedHeight: height * 0.2,
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: true,
                title: CircleAvatar(backgroundColor: Colors.white, maxRadius: 30, child: Icon(Icons.medical_services)
                    // Icon(Icons.badge_rounded, size: 40),
                    ),
              ),
              backgroundColor: Colors.green.shade900,
            ),
            SliverFillRemaining(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ItemDetalles(dato: "Paciente ", info: "$name "),
                ItemDetalles(dato: "Fecha ", info: "$fecha "),
                ItemDetalles(dato: "Motivo de consulta ", info: "${consulta.motivo}  "),
                TextArea(dato: "Enfermedad actual ", info: "${consulta.efermedadActual} "),
                TextArea(dato: "Diagnostico ", info: "${consulta.diganostico} "),
                TextArea(dato: "Indicaciones ", info: " ${consulta.indicaciones}  "),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tratamiento",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: consulta.tratamiento.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ListTile(
                            style: ListTileStyle.list,
                            title: Text(
                              " ${consulta.tratamiento[index]}",
                              style: const TextStyle(fontSize: 15),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        );
                      }),
                ),
              ]),
            ),
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
    final double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1),
        ),
      ),
      width: width * 0.8,
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          Text(
            "$dato: $info ",
            style: const TextStyle(
              fontSize: 18,
              overflow: TextOverflow.clip,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

class TextArea extends StatelessWidget {
  const TextArea({
    super.key,
    required this.info,
    required this.dato,
  });

  final String dato;
  final String info;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.8,
      margin: const EdgeInsets.only(bottom: 15, right: 15, left: 15),
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          Text(
            "$dato: ",
            style: const TextStyle(
              fontSize: 15,
              overflow: TextOverflow.clip,
            ),
            softWrap: false,
          ),
          Text(
            "$info ",
            style: const TextStyle(
              fontSize: 18,
              overflow: TextOverflow.visible,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
