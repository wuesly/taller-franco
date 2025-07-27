import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/detalleVehiculo.dart';
import 'package:flutter_application_2/views/loginScreen.dart';
import 'package:flutter_application_2/views/menuDrawerPerfil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  final Color fondo = Color(0xFFFFFFFF);
  final Color primario = Color.fromARGB(255, 21, 127, 184);
  final Color secundario = Color.fromARGB(255, 79, 109, 134);
  final Color detalle = Color.fromARGB(255, 215, 76, 16);
  final Color texto = Color.fromARGB(255, 82, 78, 78);

  List<dynamic> listaDeAutos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAutos();
  }

  Future<void> fetchAutos() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9000/api/cars'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          listaDeAutos = data.map((car) {
            car['imageUrl'] ??= 'https://via.placeholder.com/50';
            return car;
          }).toList();
          isLoading = false;
        });
      } else {
        print('❌ Error al obtener vehículos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error de conexión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      drawer: Menudrawerperfil(),
      appBar: AppBar(
        title: Text('Alquiler de vehículos'),
        backgroundColor: primario,
        foregroundColor: fondo,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: primario),
                hintText: 'Buscar vehículo',
                hintStyle: TextStyle(color: texto.withOpacity(0.5)),
                filled: true,
                fillColor: secundario,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: listaDeAutos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final auto = listaDeAutos[index];
                        final brand = auto['brand'] ?? 'Marca';
                        final model = auto['model'] ?? 'Modelo';
                        final available = auto['available'] ?? false;
                        final imageUrl = auto['imageUrl'] ?? 'https://via.placeholder.com/50';

                        return ListTile(
                          leading: Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.car_crash),
                          ),
                          title: Text('$brand Modelo $model'),
                          subtitle: Text('Disponible: ${available ? 'Sí' : 'No'}'),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                color: Colors.blue[300]),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalleVehiculo(vehiculo: auto),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Alquiler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
        ],
      ),
    );
  }
}
