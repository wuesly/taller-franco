import 'package:flutter/foundation.dart'; // kIsWeb
import 'dart:io' show Platform; // Solo para móvil/desktop

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web usa tu URL deploy en Render
      return 'https://alquiler-vehiculos-zvdu.onrender.com/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:9000/api';
    } else {
      return 'http://localhost:9000/api';
    }
  }
}
