import '../imports/imports.dart';

class ImageDetailsPage extends StatelessWidget {
  final Map<String, dynamic> image;

  const ImageDetailsPage({Key? key, required this.image}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
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
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'A imagem não pode ser carregada, pois é um arquivo diferente de imagem. Por favor, clique no botão próximo do copyright para abrir o arquivo no navegador.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
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
            title: const Text('Sinopse:'),
            subtitle: Text(image['explanation']),
          ),
          if (image['media_type'] == 'video')
            Center(
              child: ElevatedButton(
                  onPressed: () => _launchURL(image['url']),
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(150, 50))),
                  child: const Text(
                    'Abrir',
                    style: TextStyle(fontSize: 26),
                    )),
            ),
        ],
      ),
    );
  }
}
// ignore_for_file: deprecated_member_use
