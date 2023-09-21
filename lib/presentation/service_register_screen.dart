import 'dart:convert';

import 'package:consumo_api_libros/presentation/widgets/menu_appbar.dart';
import 'package:consumo_api_libros/presentation/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceRegisterScreen extends StatefulWidget {
  const ServiceRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ServiceRegisterScreen> createState() => _ServiceRegisterScreenState();
}

class _ServiceRegisterScreenState extends State<ServiceRegisterScreen> {
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String estado = "Activo";

  final String url =
      'https://trabajo-presentacion-barberia.onrender.com/api/services';

  void registroServicio() async {
    final nombre = serviceNameController.text;
    final descripcion = descriptionController.text;
    final precio = priceController.text;

    if (nombre.isEmpty || descripcion.isEmpty || precio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete todos los campos',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return;
    }

    try {
      final double price = double.parse(precio);
      if (price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'El precio debe ser mayor que cero',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingrese un precio válido',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return;
    }

    final body = jsonEncode({
      'serviceName': nombre,
      'description': descripcion,
      'price': int.parse(precio),
      'estado': estado,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registro exitoso',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de registro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    drawer: MenuDrawer(),
    appBar: MenuAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: serviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese su nombre',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese su descripción',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  hintText: 'Ingrese su precio',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  registroServicio();
                },
                child: const Text('Registrarse'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}