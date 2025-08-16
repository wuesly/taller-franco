import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/detalleVehiculo.dart';
import 'package:flutter_application_2/views/menuDrawerPerfil.dart';
import '../api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  final Color fondo = Color(0xFFFFFFFF);
  final Color primario = Color.fromARGB(255, 69, 15, 85);
  final Color secundario = Color.fromARGB(255, 91, 76, 134);
  final Color detalle = Color.fromARGB(255, 46, 66, 82);
  final Color texto = Color.fromARGB(255, 82, 78, 78);

  List<dynamic> listaDeAutos = [];
  bool isLoading = true;
  int _currentIndex = 0; // 0 = Inicio, 1 = Alquileres

  @override
  void initState() {
    super.initState();
    fetchAutos();
  }

  Future<void> fetchAutos() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/cars'),
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

  List<dynamic> get vehiculosFiltrados {
    if (_currentIndex == 0) return listaDeAutos; // Todos
    return listaDeAutos.where((auto) => !(auto['available'] ?? true)).toList(); // Alquilados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      drawer: Menudrawerperfil(),
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Todos los Vehículos' : 'Vehículos Alquilados'),
        backgroundColor: primario,
        foregroundColor: fondo,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (_currentIndex == 0) // Buscar solo en "Inicio"
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
                      itemCount: vehiculosFiltrados.length,
                      itemBuilder: (BuildContext context, int index) {
                        final auto = vehiculosFiltrados[index];
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
                            icon: Icon(Icons.arrow_forward_ios, color: Colors.blue[300]),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalleVehiculo(vehiculo: auto),
                                ),
                              ).then((vehiculoActualizado) {
                                // 🔹 Aquí se actualiza la lista cuando regresas de DetalleVehiculo
                                if (vehiculoActualizado != null) {
                                  setState(() {
                                    listaDeAutos[index] = vehiculoActualizado;
                                  });
                                }
                              });
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
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Alquileres',
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
