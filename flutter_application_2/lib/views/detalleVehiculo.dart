import 'package:flutter/material.dart';
import 'medioPago.dart';

class DetalleVehiculo extends StatefulWidget {
  final Map<String, dynamic> vehiculo;

  const DetalleVehiculo({super.key, required this.vehiculo});

  @override
  State<DetalleVehiculo> createState() => _DetalleVehiculoState();
}

class _DetalleVehiculoState extends State<DetalleVehiculo> {
  late Map<String, dynamic> vehiculo;

  @override
  void initState() {
    super.initState();
    vehiculo = widget.vehiculo;
  }

  @override
  Widget build(BuildContext context) {
    final disponible = vehiculo['available'] ?? false;
    final imageUrl = vehiculo['imageUrl'] ?? 'https://picsum.photos/300/200';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Vehículo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              imageUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(Icons.car_crash, size: 100),
            ),
            SizedBox(height: 16),
            Text('Marca: ${vehiculo['brand']}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Modelo: ${vehiculo['model']}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(disponible ? 'Disponible' : 'No disponible',
                style: TextStyle(
                  fontSize: 16,
                  color: disponible ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                )),
            Spacer(),
            ElevatedButton(
              onPressed: disponible
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MedioPago(vehiculo: vehiculo),
                        ),
                      ).then((actualizado) {
                        if (actualizado != null) {
                          setState(() => vehiculo = actualizado);
                        }
                      });
                    }
                  : null,
              child: Text('Alquilar Vehículo'),
            ),
          ],
        ),
      ),
    );
  }
}
