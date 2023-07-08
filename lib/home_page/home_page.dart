import '../imports/imports.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> imageUrls = [];
  int _selectedImageCount = 14;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    generateDates(_selectedImageCount);
  }

  void generateDates(int imageCount) {
    List<String> filmIds = [
      'tt9362722',
      'tt1877830',
      'tt0816692',
      'tt0271383',
      'tt0246578',
      'tt0861739',
      'tt0144084',
      'tt0137523',
      'tt5180504',
      'tt5753856',
      'tt4154796',
      'tt0298148'
    ];

    for (var id in filmIds) {
      fetchImageData(id);
    }
  }

  DateTime generateRandomDate(DateTime start, DateTime end) {
    Duration randomDuration = Duration(
      days: Random().nextInt(end.difference(start).inDays) + 1,
    );
    return start.add(randomDuration);
  }

  Future<void> fetchImageData(String filmId) async {
    setState(() {
      isLoading = true;
    });

    final movieResponse = await http.get(
      Uri.parse('https://moviesdatabase.p.rapidapi.com/titles/$filmId'),
      headers: {
        "X-RapidAPI-Key": "9e95e0c27cmsh9eda1e618e22853p1418f3jsn3fe2d9da6093",
        "X-RapidAPI-Host": "moviesdatabase.p.rapidapi.com"
      },
    );

    setState(() {
      isLoading = false;
    });

    if (movieResponse.statusCode == 200) {
      Map<String, dynamic> response = json.decode(movieResponse.body);

      Map<String, dynamic> formattedItem = {};
      formattedItem['url'] = response["results"]['primaryImage']['url'];
      formattedItem['title'] = response["results"]['titleText']['text'];
      String day = "${response['results']['releaseDate']['day']}".length == 1
          ? '0${response["results"]['releaseDate']['day']}'
          : '${response["results"]['releaseDate']['day']}';
      String month =
          "${response['results']['releaseDate']['month']}".length == 1
              ? '0${response["results"]['releaseDate']['month']}'
              : '${response["results"]['releaseDate']['month']}';
      formattedItem['date'] =
          "${response["results"]['releaseDate']['year']}-$month-$day";
      formattedItem['explanation'] = "Não fornecido pela API";

      setState(() {
        imageUrls.add(formattedItem);
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
    final result =
        await Navigator.pushNamed(context, SettingsPage.routeName) as int?;
    if (result != null) {
      setState(() {
        _selectedImageCount = result;
      });
      clearImages();
    }
  }

  Future<void> _refreshImages() async {
    clearImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FILMES',
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
        onRefresh: _refreshImages,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
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
                              builder: (context) =>
                                  ImageDetailsPage(image: item),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: imageUrl != null
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.black,
                                            child: const Center(
                                              child: Text(
                                                "Abra para mais informações",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      )
                                    : Container(),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black54
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatDate(date),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
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
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: clearImages,
        child: const Icon(
          Icons.refresh,
          color: Colors.black,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
