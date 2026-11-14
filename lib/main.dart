import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CronologiaFidelApp());
}

class CronologiaFidelApp extends StatelessWidget {
  const CronologiaFidelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronología Fidel Castro Ruz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B0000),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F5F0),
      ),
      home: const PantallaCronologia(),
    );
  }
}

class EventoHistorico {
  final String fecha;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? imagen;
  final List<FuenteHistorica> fuentes;

  const EventoHistorico({
    required this.fecha,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.imagen,
    required this.fuentes,
  });

  factory EventoHistorico.fromJson(Map<String, dynamic> json) {
    final fuentesJson = json['sources'] as List<dynamic>? ?? [];

    return EventoHistorico(
      fecha: json['date'] as String? ?? '',
      titulo: json['title'] as String? ?? 'Sin título',
      descripcion: json['description'] as String? ?? '',
      categoria: json['category'] as String? ?? 'Sin categoría',
      imagen: json['image'] as String?,
      fuentes: fuentesJson
          .map(
            (fuente) => FuenteHistorica.fromJson(
              fuente as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class FuenteHistorica {
  final String nombre;
  final String url;

  const FuenteHistorica({
    required this.nombre,
    required this.url,
  });

  factory FuenteHistorica.fromJson(Map<String, dynamic> json) {
    return FuenteHistorica(
      nombre: json['name'] as String? ?? 'Fuente no especificada',
      url: json['url'] as String? ?? '',
    );
  }
}

class AnioHistorico {
  final int anio;
  final String titulo;
  final List<EventoHistorico> eventos;

  const AnioHistorico({
    required this.anio,
    required this.titulo,
    required this.eventos,
  });

  factory AnioHistorico.fromJson(Map<String, dynamic> json) {
    final eventosJson = json['events'] as List<dynamic>? ?? [];

    return AnioHistorico(
      anio: json['year'] as int,
      titulo: json['title'] as String? ?? 'Sin título',
      eventos: eventosJson
          .map(
            (evento) => EventoHistorico.fromJson(
              evento as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class PantallaCronologia extends StatefulWidget {
  const PantallaCronologia({super.key});

  @override
  State<PantallaCronologia> createState() => _PantallaCronologiaState();
}

class _PantallaCronologiaState extends State<PantallaCronologia> {
  late Future<List<AnioHistorico>> _cronologiaFuture;

  @override
  void initState() {
    super.initState();
    _cronologiaFuture = cargarCronologia();
  }

  Future<List<AnioHistorico>> cargarCronologia() async {
    final contenido = await rootBundle.loadString(
      'assets/data/cronologia.json',
    );

    final datos = jsonDecode(contenido) as List<dynamic>;

    final cronologia = datos
        .map(
          (dato) => AnioHistorico.fromJson(
            dato as Map<String, dynamic>,
          ),
        )
        .toList();

    cronologia.sort((a, b) => a.anio.compareTo(b.anio));

    return cronologia;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronología 1926–2016'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/images/logo.png',
              height: 120,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.history_edu,
                  size: 80,
                  color: Color(0xFF8B0000),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Cronología documentada de Fidel Castro Ruz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<AnioHistorico>>(
              future: _cronologiaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No se pudo cargar la cronología.\n\n'
                        'Verifica el archivo cronologia.json.\n\n'
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final cronologia = snapshot.data ?? [];

                if (cronologia.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay acontecimientos disponibles.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cronologia.length,
                  itemBuilder: (context, index) {
                    final anio = cronologia[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF8B0000),
                          foregroundColor: Colors.white,
                          child: Text(
                            anio.anio.toString().substring(2),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        title: Text(
                          '${anio.anio} · ${anio.titulo}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${anio.eventos.length} acontecimiento(s) documentado(s)',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PantallaAnio(anio: anio),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PantallaAnio extends StatelessWidget {
  final AnioHistorico anio;

  const PantallaAnio({
    super.key,
    required this.anio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Año ${anio.anio}'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: anio.eventos.isEmpty
          ? const Center(
              child: Text(
                'No hay acontecimientos incorporados para este año.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '${anio.anio}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFF8B0000),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  anio.titulo,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                ...anio.eventos.map(
                  (evento) => TarjetaEvento(evento: evento),
                ),
              ],
            ),
    );
  }
}

class TarjetaEvento extends StatelessWidget {
  final EventoHistorico evento;

  const TarjetaEvento({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (evento.imagen != null && evento.imagen!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Image.asset(
                  evento.imagen!,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            if (evento.fecha.isNotEmpty)
              Text(
                evento.fecha,
                style: const TextStyle(
                  color: Color(0xFF8B0000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 6),
            Text(
              evento.titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(evento.categoria),
              backgroundColor: const Color(0xFFF1E0D0),
            ),
            const SizedBox(height: 10),
            Text(
              evento.descripcion,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            if (evento.fuentes.isNotEmpty) ...[
              const SizedBox(height: 18),
              const Divider(),
              const Text(
                'Fuentes consultadas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              ...evento.fuentes.map(
                (fuente) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    '• ${fuente.nombre}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PantallaError extends StatelessWidget {
  final String mensaje;
  final String detalle;

  const _PantallaError({
    required this.mensaje,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 70,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                detalle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
