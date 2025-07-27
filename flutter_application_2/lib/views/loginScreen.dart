import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/menuPrincipal.dart';
import 'package:flutter_application_2/views/registroUsuarios.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color fondo = Color(0xFFAFDDFF);
  final Color encabezado = Color(0xFF6DB5FF);
  final Color campos = Color(0xFFFFECD8);
  final Color boton = Color(0xFFFF914D);
  final Color texto = Color(0xFF222222);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Por favor completa todos los campos");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.101.23:9000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String nombre = data['user']['name'];

        showMessage("¡Bienvenido $nombre!", success: true);

        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuPrincipal()),
          );
        });
      } else {
        final data = jsonDecode(response.body);
        showMessage(data['message'] ?? 'Credenciales incorrectas');
      }
    } catch (e) {
      showMessage("Error de conexión con el servidor");
    }

    setState(() => isLoading = false);
  }

  void showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
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
          children: [
            Icon(Icons.person_pin, size: 80, color: encabezado),
            SizedBox(height: 16),
            Text(
              "Bienvenido",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: encabezado),
            ),
            SizedBox(height: 8),
            Text(
              "Inicia sesión para continuar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: texto.withOpacity(0.7)),
            ),
            SizedBox(height: 90),
            TextField(
              controller: emailController,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                filled: true,
                fillColor: campos,
                labelText: "Correo electrónico",
                labelStyle: TextStyle(color: texto),
                prefixIcon: Icon(Icons.email, color: encabezado),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                filled: true,
                fillColor: campos,
                labelText: "Contraseña",
                labelStyle: TextStyle(color: texto),
                prefixIcon: Icon(Icons.lock, color: encabezado),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: boton,
                minimumSize: Size(double.infinity, 48),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Iniciar sesión", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              children: [
                Text("¿Olvidaste tu contraseña?", style: TextStyle(color: texto)),
                TextButton(
                  onPressed: () {},
                  child: Text("Recuperar", style: TextStyle(color: encabezado, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              children: [
                Text("¿No tienes cuenta?", style: TextStyle(color: texto)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistroUsuarios()));
                  },
                  child: Text("Regístrate", style: TextStyle(color: encabezado, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
