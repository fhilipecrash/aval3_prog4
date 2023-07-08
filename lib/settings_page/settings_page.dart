import '../imports/imports.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _imageCountController = TextEditingController();

  @override
  void dispose() {
    _imageCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreatorsList(),
          ],
        ),
      ),
    );
  }
}

class CreatorsList extends StatelessWidget {
  const CreatorsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Criadores:',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text('Luis Henrique Sousa Brasil', style: TextStyle(fontSize: 20)),
          Text('Laercio Souza da Silva', style: TextStyle(fontSize: 20)),
          Text('José Fhilipe Martins Coelho', style: TextStyle(fontSize: 20)),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
