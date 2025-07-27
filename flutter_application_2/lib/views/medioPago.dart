import 'package:flutter/material.dart';

class MedioPago extends StatelessWidget {
  const MedioPago({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primario = Color.fromARGB(255, 21, 127, 184);
    final Color fondo = Color(0xFFFFFFFF);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medio de Pago'),
        backgroundColor: primario,
        foregroundColor: fondo,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.credit_card, color: Colors.blue),
            title: Text('Tarjeta de Crédito o Débito'),
            tileColor: Colors.grey[200],
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionaste Tarjeta de Crédito/Débito')),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_balance_wallet, color: Colors.indigo),
            title: Text('PayPal'),
            tileColor: Colors.grey[200],
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionaste PayPal')),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_balance, color: Colors.green),
            title: Text('Transferencia Bancaria'),
            tileColor: Colors.grey[200],
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionaste Transferencia Bancaria')),
              );
            },
          ),
        ],
      ),
    );
  }
}
