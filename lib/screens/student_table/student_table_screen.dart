import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentTableScreen extends StatefulWidget {
  const StudentTableScreen({super.key});

  @override
  _StudentTableScreenState createState() => _StudentTableScreenState();
}

class _StudentTableScreenState extends State<StudentTableScreen> {
  String _selectedTeam = 'E12'; // Equipo seleccionado por defecto

  // Datos de los estudiantes en diferentes equipos
  final Map<String, List<Map<String, String>>> _teamData = {
    'E12': [
      {'name': 'Darinel', 'phone': '9613021060', 'matricula': '221192'},
      {'name': 'Ulises', 'phone': '9651032159', 'matricula': '213691'},
      {'name': 'Merlin', 'phone': '9515271070', 'matricula': '221255'},
      {'name': '', 'phone': '', 'matricula': ''},
    ],
    'E1': [
      {'name': 'Eduardo', 'phone': '9611272389', 'matricula': '213377'},
      {'name': 'Maria José', 'phone': '9631333708', 'matricula': '987654'},
      {'name': 'Manuel', 'phone': '9612458375', 'matricula': '112233'},
      {'name': 'Diego', 'phone': '9613280361', 'matricula': '445566'},
    ],
  };

  void _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener los estudiantes del equipo seleccionado
    final students = _teamData[_selectedTeam] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Contact List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown para seleccionar equipo
            DropdownButton<String>(
              value: _selectedTeam,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTeam = newValue!;
                });
              },
              items:
                  _teamData.keys.map<DropdownMenuItem<String>>((String team) {
                return DropdownMenuItem<String>(
                  value: team,
                  child: Text(team),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Tabla de estudiantes ajustada en altura según el número de filas
            students.isNotEmpty
                ? Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      // Ajusta la altura en función del número de estudiantes
                      height: (students.length * 60).toDouble(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20.0,
                          columns: const [
                            DataColumn(
                                label: Text('Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Phone Number',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Matricula',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: students.map((student) {
                            return _buildDataRow(
                              student['name']!,
                              student['phone']!,
                              student['matricula']!,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                : const Text('No hay estudiantes en este equipo.'),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String name, String phoneNumber, String matricula) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(
          TextButton(
            onPressed: () => _makePhoneCall(phoneNumber),
            child: Text(phoneNumber, style: const TextStyle(color: Colors.blue)),
          ),
        ),
        DataCell(Text(matricula)),
      ],
    );
  }
}
