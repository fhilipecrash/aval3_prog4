import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './image_details_page.dart';
import './settings_page.dart';
import 'date_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> imageUrls = [];
  int _selectedImageCount = 14;

  @override
  void initState() {
    super.initState();
    generateDates(_selectedImageCount);
  }

  void generateDates(int imageCount) {
    for (var i = 0; i < imageCount; i++) {
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
    generateDates(_selectedImageCount);
  }

  void openSettingsPage() async {
    final result = await Navigator.pushNamed(context, SettingsPage.routeName) as int?;
    if (result != null) {
      setState(() {
        _selectedImageCount = result;
      });
      clearImages();
    }
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
        actions: [
          IconButton(
            onPressed: openSettingsPage,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          clearImages();
        },
        child: Column(
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
      ),
    );
  }
}
