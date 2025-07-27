import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/medioPago.dart';

class DetalleVehiculo extends StatelessWidget {
  final Map<String, dynamic> vehiculo;

  const DetalleVehiculo({super.key, required this.vehiculo});

  @override
  Widget build(BuildContext context) {
    final Color primario = Color.fromARGB(255, 21, 127, 184);
    final Color fondo = Color(0xFFFFFFFF);
    final bool disponible = vehiculo['available'] ?? false;

    final String marca = vehiculo['brand'] ?? 'Desconocida';
    final String modelo = vehiculo['model'] ?? 'Desconocido';

    // ✅ Imagen por defecto válida para Flutter Web
    final String imageUrl = vehiculo['imageUrl']?.toString().isNotEmpty == true
        ? vehiculo['imageUrl']
        : 'https://picsum.photos/300/200';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Vehículo'),
        backgroundColor: primario,
        foregroundColor: fondo,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.car_crash, size: 100),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Marca: $marca',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Modelo: $modelo',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (vehiculo['anio'] != null)
              Text(
                'Año: ${vehiculo['anio']}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 8),
            Text(
              disponible ? 'Disponible' : 'No Disponible',
              style: TextStyle(
                fontSize: 16,
                color: disponible ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: disponible
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedioPago(),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: disponible
                    ? Color.fromARGB(255, 215, 76, 16)
                    : Colors.grey,
              ),
              child: Text(
                'Alquilar Vehículo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
