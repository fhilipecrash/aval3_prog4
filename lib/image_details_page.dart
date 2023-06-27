import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    'A imagem não pode ser carregada, pois é um vídeo. Por favor, clique no botão próximo do copyright para assistir.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
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
                child: const Text('Assistir'),
              ),
            ),
        ],
      ),
    );
  }
}
