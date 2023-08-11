import 'package:app_medica/controller/paciente_controller.dart';
import 'package:app_medica/models/pacientes.dart';
import 'package:app_medica/routes/routes.dart';
import 'package:app_medica/widget/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PacienteScreen extends StatelessWidget {
  const PacienteScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouterHelper.getAddPaciente());
        },
        child: const Icon(
          Icons.person_add_rounded,
          size: 30,
        ),
      ),
      body: GetBuilder<PacienteController>(
        builder: (pacientcontroller) {
          final pacient = MySearchDelegate(pacientcontroller.pacientes.map((e) => '${e.cedula}').toList());
          return Scaffold(
            appBar: AppBar(
              elevation: 10,
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () async {
                      final String? selected = await showSearch<String>(
                        context: context,
                        delegate: pacient,
                      );
                      if (selected != null && selected.trim().isNotEmpty) {
                        final Paciente? irA = pacientcontroller.findPacienteByCedula(int.parse(selected));
                        irA != null
                            ? Get.toNamed(RouterHelper.getDetallesPaciente(irA.id.toString()))
                            : ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Paciente de cedula $selected no encontrado'),
                                ),
                              );
                      }
                    },
                    icon: const Icon(Icons.search)),
              ],
              title: Text(
                "Pacientes ${pacientcontroller.pacientes.length}",
              ),
            ),
            body: AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.all(w / 30),
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: pacientcontroller.pacientes.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: FadeInAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 2500),
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: w / 30),
                            height: h / 15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: itemList(index, pacientcontroller.pacientes[index])),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

ListTile itemList(int index, Paciente name) {
  return ListTile(
    onTap: () => Get.toNamed(RouterHelper.getDetallesPaciente(name.id.toString())),
    leading: const CircleAvatar(
      backgroundColor: Colors.grey,
      child: Icon(
        Icons.person_outline_outlined,
        color: Colors.blue,
      ),
    ),
    title: Text(" ${name.nombre} ${name.apellido} ${name.cedula}  "),
  );
}
