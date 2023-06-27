import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NASA API',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> imageUrls = [];

  @override
  void initState() {
    super.initState();
    generateDates();
  }

  void generateDates() {
    for (var i = 0; i < 20; i++) {
      DateTime startDate = DateTime(1995, 7, 1);
      DateTime currentDate = DateTime.now();
      DateTime randomDate = generateRandomDate(startDate, currentDate);
      fetchImageData(randomDate);
    }
  }

  DateTime generateRandomDate(DateTime start, DateTime end) {
    Duration randomDuration = Duration(
      days: Random().nextInt(end.difference(start).inDays) + 1,
    );
    return start.add(randomDuration);
  }

  Future<void> fetchImageData(DateTime date) async {
    String apiKey = "8uB1eb3DyZqKQLKsndfi2F69gZD0PDtqPQgc9GaL";
    String url =
        "https://api.nasa.gov/planetary/apod?api_key=$apiKey&date=${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrls.add(data);
      });
    }
  }

  void clearImages() {
    setState(() {
      imageUrls.clear();
    });
    generateDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NASA API',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: clearImages,
            child: const Text('Atualizar imagens'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                final item = imageUrls[index];
                final imageUrl = item['url'];
                final title = item['title'];
                final date = DateTime.parse(item['date']);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailsPage(image: item),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: Text(
                                    "Abra para obter mais informações",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatDate(date),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class ImageDetailsPage extends StatelessWidget {
  final Map<String, dynamic> image;

  const ImageDetailsPage({Key? key, required this.image}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image['title']),
      ),
      body: ListView(
        children: [
          Image.network(
            image['url'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey,
                child: const Center(
                  child: Text(
                    'A imagem não pode ser carregada, pois é um vídeo no YouTube. Por favor, clique no botão abaixo do copyright para assistir no aplicativo do YouTube.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Título:'),
            subtitle: Text(image['title']),
          ),
          ListTile(
            title: const Text('Data:'),
            subtitle: Text(image['date']),
          ),
          ListTile(
            title: const Text('Descrição da imagem:'),
            subtitle: Text(image['explanation']),
          ),
          ListTile(
            title: const Text('Copyright:'),
            subtitle: Text(image['copyright'] ?? 'Não fornecido pela API'),
          ),
          if (image['media_type'] == 'video')
            Center(
              child: ElevatedButton(
                onPressed: () => _launchURL(image['url']),
                child: const Text('Assistir no YouTube'),
              ),
            ),
        ],
      ),
    );
  }
}

String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}
