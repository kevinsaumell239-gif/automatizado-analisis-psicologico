import 'package:flutter/material.dart';

void main() {
  runApp(const AutomatizadoAnalisisApp());
}

class AutomatizadoAnalisisApp extends StatelessWidget {
  const AutomatizadoAnalisisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automatizado de Análisis Psicológico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const PantallaInicio(),
    );
  }
}

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automatizado de Análisis Psicológico'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.psychology,
              size: 90,
              color: Color(0xFF2563EB),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bienvenido/a',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Seleccione el tipo de usuario para continuar.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.science),
              label: const Text('Investigador'),
              onPressed: () {},
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Encuestado'),
              onPressed: () {},
            ),
            const SizedBox(height: 28),
            const Text(
              'Esta plataforma es experimental y no sustituye la evaluación de profesionales de la salud mental.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
