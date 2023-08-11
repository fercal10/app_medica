import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

import 'package:app_medica/models/consulta.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateJackie(PdfPageFormat format, Consulta consulta) async {
  // final foto = File('assets/header_oscar.png');
  // final header = pw.MemoryImage(
  //   (await rootBundle.load('assets/header_oscar.png')).buffer.asUint8List(),
  // );

  final pdf = pw.Document(
      author: "App_medica",
      title:
          "Consulta ${consulta.paciente.target!.consultas.length}-${consulta.paciente.target!.nombre}${consulta.paciente.target!.apellido}.pdf");

  final pageTheme = await _myPageTheme(format, consulta);

  pdf.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      build: (pw.Context context) {
        // final dif = DateTime.now().difference(consulta.paciente.target!.fechaNacimiento);
        // final edad = (dif.inDays / 365.25).floor();
        final String medicamentos = consulta.tratamiento.join('   -');
        return [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text("Medicamentos: ", style: const pw.TextStyle(fontSize: 24)),
            pw.Text("- $medicamentos ", style: const pw.TextStyle(fontSize: 20), softWrap: true),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text("Indicaciones:  ", style: const pw.TextStyle(fontSize: 24)),
            pw.Text("${consulta.indicaciones}  ", style: const pw.TextStyle(fontSize: 20), softWrap: true),
          ]),
        ];
      }));
  return pdf.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format, Consulta consulta) async {
  final fondo = pw.MemoryImage(
    (await rootBundle.load('assets/jackie.jpg')).buffer.asUint8List(),
  );

  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 4.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 6.0 * PdfPageFormat.cm);
  return pw.PageTheme(
    pageFormat: format,
    buildBackground: (pw.Context context) {
      final fecha = "${consulta.fecha!.day} ${consulta.fecha!.month} ${consulta.fecha!.year}";
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Positioned(
              child: pw.SizedBox(
                  child: pw.Image(fondo,
                      alignment: pw.Alignment.center,
                      fit: pw.BoxFit.scaleDown,
                      height: format.height,
                      width: format.width)),
              left: 0,
              top: 0,
            ),
            pw.Positioned(
              child: pw.Text(' ${consulta.paciente.target?.nombre} ${consulta.paciente.target?.apellido}',
                  style: const pw.TextStyle(fontSize: 20)),
              left: 5.5 * PdfPageFormat.cm,
              bottom: 4.1 * PdfPageFormat.cm,
            ),
            pw.Positioned(
              child: pw.Text(fecha, style: const pw.TextStyle(fontSize: 20, wordSpacing: 6)),
              left: 5.2 * PdfPageFormat.cm,
              bottom: 2.9 * PdfPageFormat.cm,
            ),
          ],
        ),
      );
    },
  );
}

Future<Uint8List> generateResume(PdfPageFormat format, Consulta? consulta) async {
  // final foto = File('assets/header_oscar.png');
  final header = pw.MemoryImage(
    (await rootBundle.load('assets/header_oscar.png')).buffer.asUint8List(),
  );
  final sello = pw.MemoryImage(
    (await rootBundle.load('assets/sello_oscar.png')).buffer.asUint8List(),
  );

  final pdf = pw.Document();

  if (consulta == null) return pdf.save();
  pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(20),
      pageFormat: format,
      build: (pw.Context context) {
        final fecha = " ${consulta.fecha!.day}/${consulta.fecha!.month}/${consulta.fecha!.year}";
        final dif = DateTime.now().difference(consulta.paciente.target!.fechaNacimiento);
        final edad = (dif.inDays / 365.25).floor();
        final String medicamentos = consulta.tratamiento.join('   -');

        return pw.Container(
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(header, height: 200),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text("Indicaciones", style: const pw.TextStyle(fontSize: 18), softWrap: true),
                  pw.Text("Fecha $fecha", style: const pw.TextStyle(fontSize: 18), softWrap: true),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text("Paciente: ${consulta.paciente.target?.nombre} ${consulta.paciente.target?.apellido} ",
                      style: const pw.TextStyle(fontSize: 18), softWrap: true),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text("Cedula :${consulta.paciente.target?.cedula}",
                      style: const pw.TextStyle(fontSize: 18), softWrap: true),
                  pw.Text("Edad $edad Años", style: const pw.TextStyle(fontSize: 18), softWrap: true),
                ]),
                pw.SizedBox(height: 5),
                pw.Text("Medicamentos ", style: const pw.TextStyle(fontSize: 18), softWrap: true),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  width: 600,
                  height: 170,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 2, color: PdfColor.fromHex("#275673")),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Wrap(children: [
                    pw.Text("- $medicamentos ", style: const pw.TextStyle(fontSize: 15), softWrap: true),
                  ]),
                ),
                pw.SizedBox(height: 10),
                pw.Text("Indicaciones ", style: const pw.TextStyle(fontSize: 15), softWrap: true),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  width: 600,
                  height: 120,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 2, color: PdfColor.fromHex("#275673")),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Text("${consulta.indicaciones} ", style: const pw.TextStyle(fontSize: 15), softWrap: true),
                ),
                pw.SizedBox(height: 10),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                  pw.Image(sello, height: 80),
                ]),
                pw.SizedBox(height: 20),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                  pw.Container(
                    height: 5,
                    width: 400,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#275673'),
                      // border: pw.Border.all(width: 2, color: PdfColor.fromHex("#00f")),
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                  )
                ]),
              ]),
        );
      }));
  return pdf.save();
}
