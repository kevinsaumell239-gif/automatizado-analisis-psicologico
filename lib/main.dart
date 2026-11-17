import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FidelCentenarioApp());
}

/// Paleta cromática verde olivo histórica y solemne
class ColoresApp {
  static const Color verdeOlivoOscuro = Color(0xFF263A29);
  static const Color verdeOlivoMedio  = Color(0xFF3E543B);
  static const Color verdeOlivoSuave  = Color(0xFF5E7153);
  static const Color doradoHistorico  = Color(0xFFC5A059);
  static const Color fondoClaro       = Color(0xFFF7F8F5);
  static const Color superficieTarjeta= Color(0xFFFFFFFF);
  static const Color textoPrincipal   = Color(0xFF1B241B);
  static const Color textoSecundario  = Color(0xFF556052);
}

class FidelCentenarioApp extends StatelessWidget {
  const FidelCentenarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centenario Fidel Castro Ruz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ColoresApp.fondoClaro,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColoresApp.verdeOlivoOscuro,
          primary: ColoresApp.verdeOlivoOscuro,
          secondary: ColoresApp.doradoHistorico,
          surface: ColoresApp.superficieTarjeta,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ColoresApp.verdeOlivoOscuro,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
      ),
      home: const PantallaPrincipal(),
    );
  }
}

// ===============================================================
// MODELOS DE DATOS
// ===============================================================

class EventoHistorico {
  final String date;
  final String title;
  final String description;
  final String category;

  const EventoHistorico({
    required this.date,
    required this.title,
    required this.description,
    required this.category,
  });

  factory EventoHistorico.fromJson(Map<String, dynamic> json) {
    return EventoHistorico(
      date: (json['date'] ?? '').toString(),
      title: (json['title'] ?? 'Sin título').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? 'General').toString(),
    );
  }
}

class AnioHistorico {
  final int year;
  final String title;
  final List<EventoHistorico> events;

  const AnioHistorico({
    required this.year,
    required this.title,
    required this.events,
  });

  factory AnioHistorico.fromJson(Map<String, dynamic> json) {
    final rawYear = json['year'] ?? 0;
    final int parsedYear = rawYear is int ? rawYear : int.tryParse(rawYear.toString()) ?? 0;
    final eventsRaw = (json['events'] as List<dynamic>?) ?? [];

    return AnioHistorico(
      year: parsedYear,
      title: (json['title'] ?? '').toString(),
      events: eventsRaw
          .whereType<Map<String, dynamic>>()
          .map((e) => EventoHistorico.fromJson(e))
          .toList(),
    );
  }
}

// ===============================================================
// PANTALLA PRINCIPAL
// ===============================================================

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  Future<void> _abrirSitioCentroFidel(BuildContext context) async {
    final uri = Uri.parse('https://www.centrofidel.cu');

    try {
      final lanzado = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!lanzado && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el sitio web en el navegador.'),
            backgroundColor: ColoresApp.verdeOlivoOscuro,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al conectar: $e'),
            backgroundColor: ColoresApp.verdeOlivoOscuro,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Centenario de Fidel Castro',
          style: TextStyle(letterSpacing: 0.5, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Emblema conmemorativo
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ColoresApp.verdeOlivoOscuro, ColoresApp.verdeOlivoMedio],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColoresApp.verdeOlivoOscuro.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/icon.png',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: ColoresApp.doradoHistorico, width: 2),
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: const Icon(
                              Icons.star_rounded,
                              size: 50,
                              color: ColoresApp.doradoHistorico,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColoresApp.doradoHistorico.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ColoresApp.doradoHistorico.withOpacity(0.7)),
                      ),
                      child: const Text(
                        '1926 — 2026',
                        style: TextStyle(
                          color: ColoresApp.doradoHistorico,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'FIDEL CASTRO RUZ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Homenaje en el Centenario de su Natalicio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFFE2E7DE),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Menú Principal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.textoPrincipal,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // OPCIÓN 1: Ver Cronología
              _BotonMenuPrincipal(
                titulo: 'Ver Cronología de Fidel Castro',
                subtitulo: 'Recorrido histórico documentado año a año (1926–2016)',
                icono: Icons.auto_stories_outlined,
                colorFondoIcono: ColoresApp.verdeOlivoSuave.withOpacity(0.15),
                colorIcono: ColoresApp.verdeOlivoOscuro,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PantallaCronologia(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // OPCIÓN 2: Visitar el Centro Fidel Castro
              _BotonMenuPrincipal(
                titulo: 'Visitar el Centro Fidel Castro',
                subtitulo: 'Acceder al portal oficial en www.centrofidel.cu',
                icono: Icons.language,
                colorFondoIcono: ColoresApp.doradoHistorico.withOpacity(0.15),
                colorIcono: const Color(0xFF8A6B29),
                iconoAccion: Icons.open_in_new,
                onTap: () => _abrirSitioCentroFidel(context),
              ),

              const SizedBox(height: 36),

              Center(
                child: Text(
                  'Centro Fidel Castro Ruz · La Habana, Cuba',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColoresApp.textoSecundario.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonMenuPrincipal extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color colorFondoIcono;
  final Color colorIcono;
  final IconData iconoAccion;
  final VoidCallback onTap;

  const _BotonMenuPrincipal({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.colorFondoIcono,
    required this.colorIcono,
    this.iconoAccion = Icons.chevron_right,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: ColoresApp.verdeOlivoOscuro.withOpacity(0.08)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: ColoresApp.verdeOlivoSuave.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorFondoIcono,
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, color: colorIcono, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.textoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: ColoresApp.textoSecundario,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(iconoAccion, color: ColoresApp.verdeOlivoMedio, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// PANTALLA CRONOLOGÍA (1926 - 2016)
// ===============================================================

class PantallaCronologia extends StatefulWidget {
  const PantallaCronologia({super.key});

  @override
  State<PantallaCronologia> createState() => _PantallaCronologiaState();
}

class _PantallaCronologiaState extends State<PantallaCronologia> {
  List<AnioHistorico> _todosLosAnios = [];
  List<AnioHistorico> _aniosFiltrados = [];
  bool _cargando = true;
  String _error = '';
  final TextEditingController _controladorBusqueda = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatosJson();
    _controladorBusqueda.addListener(_filtrarCronologia);
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosJson() async {
    try {
      final contenido = await rootBundle.loadString('assets/data/cronologia.json');
      final dynamic decodificado = jsonDecode(contenido);

      List<dynamic> listaJson;
      if (decodificado is List) {
        listaJson = decodificado;
      } else if (decodificado is Map<String, dynamic>) {
        listaJson = (decodificado['years'] ?? decodificado['data'] ?? []) as List<dynamic>;
      } else {
        listaJson = [];
      }

      final lista = listaJson
          .whereType<Map<String, dynamic>>()
          .map((item) => AnioHistorico.fromJson(item))
          .toList();

      lista.sort((a, b) => a.year.compareTo(b.year));

      setState(() {
        _todosLosAnios = lista;
        _aniosFiltrados = lista;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  void _filtrarCronologia() {
    final query = _controladorBusqueda.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() => _aniosFiltrados = _todosLosAnios);
      return;
    }

    setState(() {
      _aniosFiltrados = _todosLosAnios.where((a) {
        final coincideAnio = a.year.toString().contains(query);
        final coincideTitulo = a.title.toLowerCase().contains(query);
        final coincideEventos = a.events.any((e) =>
            e.title.toLowerCase().contains(query) ||
            e.description.toLowerCase().contains(query) ||
            e.category.toLowerCase().contains(query));
        return coincideAnio || coincideTitulo || coincideEventos;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronología de Fidel Castro'),
      ),
      body: Column(
        children: [
          Container(
            color: ColoresApp.verdeOlivoOscuro,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _controladorBusqueda,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar por año, evento o tema...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _controladorBusqueda.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () => _controladorBusqueda.clear(),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.12),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: ColoresApp.verdeOlivoOscuro),
                  )
                : _error.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Error al leer assets/data/cronologia.json:\n$_error',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    : _aniosFiltrados.isEmpty
                        ? const Center(
                            child: Text(
                              'No se encontraron acontecimientos coincidentes.',
                              style: TextStyle(color: ColoresApp.textoSecundario),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            itemCount: _aniosFiltrados.length,
                            itemBuilder: (context, index) {
                              final item = _aniosFiltrados[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                elevation: 1.8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: ColoresApp.verdeOlivoOscuro,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${item.year}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    item.title.isNotEmpty ? item.title : 'Año ${item.year}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColoresApp.textoPrincipal,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${item.events.length} acontecimiento(s) registrado(s)',
                                    style: const TextStyle(
                                      color: ColoresApp.textoSecundario,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: ColoresApp.verdeOlivoMedio,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PantallaDetalleAnio(anio: item),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// PANTALLA DETALLE DEL AÑO
// ===============================================================

class PantallaDetalleAnio extends StatelessWidget {
  final AnioHistorico anio;

  const PantallaDetalleAnio({
    super.key,
    required this.anio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Año ${anio.year}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColoresApp.verdeOlivoOscuro.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ColoresApp.verdeOlivoOscuro.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                Text(
                  '${anio.year}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: ColoresApp.verdeOlivoOscuro,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    anio.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (anio.events.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No hay eventos documentados para este año.'),
              ),
            )
          else
            ...anio.events.map((evento) => _TarjetaEventoHistorico(evento: evento)),
        ],
      ),
    );
  }
}

class _TarjetaEventoHistorico extends StatelessWidget {
  final EventoHistorico evento;

  const _TarjetaEventoHistorico({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: ColoresApp.verdeOlivoOscuro,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      evento.date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.verdeOlivoOscuro,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                if (evento.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: ColoresApp.verdeOlivoMedio.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      evento.category,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.verdeOlivoOscuro,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              evento.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: ColoresApp.textoPrincipal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              evento.description,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.45,
                color: ColoresApp.textoPrincipal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
