import 'package:flutter/material.dart';

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
      ),
      home: const PantallaCronologia(),
    );
  }
}

class PantallaCronologia extends StatelessWidget {
  const PantallaCronologia({super.key});

  final List<int> anios = const [
    1926,
    1927,
    1928,
    1929,
    1930,
    1931,
    1932,
    1933,
    1934,
    1935,
    1936,
    1937,
    1938,
    1939,
    1940,
    1941,
    1942,
    1943,
    1944,
    1945,
    1946,
    1947,
    1948,
    1949,
    1950,
    1951,
    1952,
    1953,
    1954,
    1955,
    1956,
    1957,
    1958,
    1959,
    1960,
    1961,
    1962,
    1963,
    1964,
    1965,
    1966,
    1967,
    1968,
    1969,
    1970,
    1971,
    1972,
    1973,
    1974,
    1975,
    1976,
    1977,
    1978,
    1979,
    1980,
    1981,
    1982,
    1983,
    1984,
    1985,
    1986,
    1987,
    1988,
    1989,
    1990,
    1991,
    1992,
    1993,
    1994,
    1995,
    1996,
    1997,
    1998,
    1999,
    2000,
    2001,
    2002,
    2003,
    2004,
    2005,
    2006,
    2007,
    2008,
    2009,
    2010,
    2011,
    2012,
    2013,
    2014,
    2015,
    2016,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronología 1926–2016'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: anios.length,
        itemBuilder: (context, index) {
          final anio = anios[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF8B0000),
                foregroundColor: Colors.white,
                child: Text(
                  anio.toString().substring(2),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              title: Text(
                'Año $anio',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Ver acontecimientos documentados',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
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
      ),
    );
  }
}

class PantallaAnio extends StatelessWidget {
  final int anio;

  const PantallaAnio({
    super.key,
    required this.anio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Año $anio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$anio',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            const Text(
              'Acontecimientos documentados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'La información histórica de este año se incorporará en la base documental de la aplicación.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const Text(
              'Las fechas, acontecimientos e imágenes se añadirán junto con sus fuentes históricas correspondientes.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
