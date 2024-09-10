import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StudentTableScreen(),
    const StarWarsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.get_app),
            label: 'GET',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Image.network(
          'https://static.vecteezy.com/system/resources/previews/034/950/530/non_2x/ai-generated-small-house-with-flowers-on-transparent-background-image-png.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

class StudentTableScreen extends StatelessWidget {
  const StudentTableScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Contact List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20.0,
                columns: const [
                  DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Matricula', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  _buildDataRow('Darinel', '9613021060', '221192'),
                  _buildDataRow('Ulises', 'number', '213691'),
                  _buildDataRow('Merlin', 'number', '----'),
                ],
              ),
            ),
          ),
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

class StarWarsScreen extends StatefulWidget {
  const StarWarsScreen({super.key});

  @override
  _StarWarsScreenState createState() => _StarWarsScreenState();
}

class _StarWarsScreenState extends State<StarWarsScreen> {
  List<dynamic> _characters = [];
  bool _isLoading = false; // Indicador de carga

  Future<void> _fetchStarWarsCharacters() async {
    setState(() {
      _isLoading = true; // Mostrar el spinner mientras se cargan los datos
    });

    final url = Uri.parse('https://swapi.dev/api/people/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _characters = data['results'];
        _isLoading = false; // Ocultar el spinner cuando los datos estén listos
      });
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Star Wars Characters'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _fetchStarWarsCharacters,
              child: const Text('Personaje de Star Wars'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // Spinner mientras se cargan los datos
                : _characters.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Height', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Skin Color', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: _characters.map((character) {
                              return DataRow(cells: [
                                DataCell(Text(character['name'])),
                                DataCell(Text(character['gender'])),
                                DataCell(Text(character['height'])),
                                DataCell(Text(character['skin_color'])),
                              ]);
                            }).toList(),
                          ),
                        ),
                      )
                    : const Text('No hay personajes para mostrar'), // Mensaje si no hay datos
          ],
        ),
      ),
    );
  }
}
