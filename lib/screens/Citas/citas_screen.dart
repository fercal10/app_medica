import 'package:app_medica/controller/citas_controller.dart';
import 'package:app_medica/models/cita.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class CitasScreen extends StatelessWidget {
  const CitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GetBuilder<CistasController>(builder: (citaC) {
        return AnimationLimiter(
          child: ListView.builder(
            padding: EdgeInsets.all(w / 30),
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: citaC.citas.length,
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
                        child: itemList(index, citaC.citas[index])),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: const FloatingActionButton(onPressed: null, child: Icon(Icons.add_alarm_rounded)),
    );
  }

  ListTile itemList(int index, Cita cita) {
    return ListTile(
      // onTap: () => Get.toNamed(RouterHelper.getDetallesPaciente(name.id.toString())),
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person_outline_outlined,
          color: Colors.black,
        ),
      ),
      title: Text(" ${cita.paciente.target!.nombre}"),
      trailing: IconButton(
        // ignore: avoid_returning_null_for_void
        onPressed: () => null, //Get.toNamed(RouterHelper.getAddConsulta(name.id.toString())),
        icon: const Icon(
          Icons.add_chart_rounded,
          size: 30,
        ),
      ),
    );
  }
}
