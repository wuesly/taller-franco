import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/loginScreen.dart';
import 'package:flutter_application_2/views/menuPrincipal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistroUsuarios extends StatefulWidget {
  const RegistroUsuarios({super.key});

  @override
  State<RegistroUsuarios> createState() => _RegistroUsuariosState();
}

class _RegistroUsuariosState extends State<RegistroUsuarios> {
  final Color fondo = Color(0xFFAFDDFF);
  final Color encabezado = Color(0xFF6DB5FF);
  final Color campos = Color(0xFFFFECD8);
  final Color boton = Color(0xFFFF914D);
  final Color texto = Color(0xFF222222);

  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  final confirmarContrasenaController = TextEditingController();

  Future<void> registrarUsuario() async {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();
    final contrasena = contrasenaController.text;
    final confirmar = confirmarContrasenaController.text;

    if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty || confirmar.isEmpty) {
      mostrarDialogo('Todos los campos son obligatorios.');
      return;
    }

    if (contrasena != confirmar) {
      mostrarDialogo('Las contraseñas no coinciden.');
      return;
    }

    try {
      final url = Uri.parse('http://localhost:9000/api/auth/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': nombre,
          'email': correo,
          'password': contrasena,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        // ✅ Registro exitoso → ir a MenuPrincipal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MenuPrincipal()),
        );
      } else {
        // ❌ Registro fallido → mostrar error
        mostrarDialogo(data['message'] ?? 'Error al registrar.');
      }
    } catch (e) {
      mostrarDialogo('Error de conexión al servidor.');
    }
  }

  void mostrarDialogo(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atención'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.person_pin, size: 80, color: encabezado),
            SizedBox(height: 16),
            Text(
              "EMPESEMOS",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: encabezado),
            ),
            SizedBox(height: 8),
            Text(
              "Crea Una Nueva Cuenta ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: texto.withOpacity(0.7)),
            ),
            SizedBox(height: 90),
            TextField(
              controller: nombreController,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                filled: true,
                fillColor: campos,
                labelText: "Nombre Completo",
                labelStyle: TextStyle(color: texto),
                prefixIcon: Icon(Icons.person, color: encabezado),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: correoController,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                filled: true,
                fillColor: campos,
                labelText: "Correo Electrónico",
                labelStyle: TextStyle(color: texto),
                prefixIcon: Icon(Icons.email, color: encabezado),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contrasenaController,
              obscureText: true,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                filled: true,
                fillColor: campos,
                labelText: "Contraseña",
                labelStyle: TextStyle(color: texto),
                prefixIcon: Icon(Icons.password, color: encabezado),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmarContrasenaController,
              obscureText: true,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                filled: true,
                fillColor: campos,
                labelText: "Confirmar Contraseña",
                labelStyle: TextStyle(color: texto),
                prefixIcon: Icon(Icons.lock, color: encabezado),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: registrarUsuario,
              style: ElevatedButton.styleFrom(
                backgroundColor: boton,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                "REGISTRAR",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("¿Ya tienes cuenta?", style: TextStyle(color: texto)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: Text(
                    "Iniciar Sesión",
                    style: TextStyle(color: encabezado, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
