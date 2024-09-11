import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
