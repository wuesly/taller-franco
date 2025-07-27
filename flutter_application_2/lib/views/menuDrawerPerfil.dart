import 'package:flutter/material.dart';

class Menudrawerperfil extends StatefulWidget {
  @override
  _MenuDrawerPerfilState createState() => _MenuDrawerPerfilState();
}

class _MenuDrawerPerfilState extends State<Menudrawerperfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Color(0xFF6B85FF),
        foregroundColor: Colors.white,
      ), // AppBar
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage("https://picsum.photos/330/200?_scale:1.0"),
            ), // CircleAvatar
          ), // Center
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  "Nombre de Usuario",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ), // TextStyle
                ), // Text
                SizedBox(height: 4),
                Text(
                  "correo@ejemplo.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ), // TextStyle
                ), // Text
              ],
            ), // Column
          ), // Center
          SizedBox(height: 32),
          ListTile(
            leading: Icon(Icons.badge, color: Color(0xFF6B85FF)),
            title: Text("Número de licencia"),
            subtitle: Text("123456789"),
          ), // ListTile
          Divider(),
          ListTile(
            leading: Icon(Icons.lock, color: Color(0xFF6B85FF)),
            title: Text("Cambiar contraseña"),
            onTap: () {
              // Acción cambiar contraseña
            },
          ), // ListTile
          Divider(),
          ListTile(
            leading: Icon(Icons.search_rounded, color: Color(0xFFFF9149)),
            title: Text("Revisar Alquileres"),
            onTap: () {
              // Acción revisar alquileres
            },
          ), // ListTile
        ],
      ), // ListView
    ); // Scaffold
  }
}
