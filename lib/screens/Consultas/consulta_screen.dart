import 'package:app_medica/controller/consultas_controller.dart';
import 'package:app_medica/models/consulta.dart';
import 'package:app_medica/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsultaScreen extends StatelessWidget {
  const ConsultaScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsultaController>(builder: (pacientcontroller) {
      return Scaffold(
        appBar: AppBar(
          elevation: 10,
          centerTitle: true,
          title: Text(
            "Consultas ${pacientcontroller.consultas.length}",
          ),
        ),
        body: ListView.builder(
          itemCount: pacientcontroller.consultas.length,
          itemBuilder: (context, index) {
            return itemList(index, pacientcontroller.consultas[index]);
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(RouterHelper.getAddConsulta()), child: const Icon(Icons.add_chart_rounded)),
      );
    });
  }

  ListTile itemList(int index, Consulta name) {
    return ListTile(
      onTap: () => Get.toNamed(RouterHelper.getDetallesConsulta(name.id.toString())),
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.medical_services_rounded,
          color: Colors.blue,
        ),
      ),
      title: Text(" ${name.motivo}"),
      trailing: const Icon(Icons.remove_red_eye_rounded),
    );
  }
}
