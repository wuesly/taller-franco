import 'package:flutter/material.dart';
import '../api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedioPago extends StatefulWidget {
  final Map<String, dynamic> vehiculo;
  const MedioPago({super.key, required this.vehiculo});

  @override
  State<MedioPago> createState() => _MedioPagoState();
}

class _MedioPagoState extends State<MedioPago> {
  bool isLoading = false;
  late Map<String, dynamic> vehiculo;

  @override
  void initState() {
    super.initState();
    vehiculo = widget.vehiculo;
  }

  Future<void> confirmarAlquiler() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/cars/${vehiculo['_id']}/rent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': 'usuario_demo'}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        vehiculo['available'] = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vehículo alquilado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, vehiculo);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Error al alquilar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión al servidor'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final disponible = vehiculo['available'] ?? false;

    return Scaffold(
      appBar: AppBar(title: Text('Medio de Pago')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Tarjeta de Crédito/Débito'),
            onTap: disponible ? confirmarAlquiler : null,
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('PayPal'),
            onTap: disponible ? confirmarAlquiler : null,
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Transferencia Bancaria'),
            onTap: disponible ? confirmarAlquiler : null,
          ),
        ],
      ),
    );
  }
}
