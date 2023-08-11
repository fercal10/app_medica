import 'package:app_medica/screens/Consultas/consulta_screen.dart';
import 'package:app_medica/screens/Pacientes/paciente_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final kTabPages = <Widget>[
      const PacienteScreen(),
      const ConsultaScreen(),
    ];
    final kBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pacientes'),
      const BottomNavigationBarItem(icon: Icon(Icons.vaccines_rounded), label: 'Consultas'),
    ];
    assert(kTabPages.length == kBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: kBottmonNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      body: kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
