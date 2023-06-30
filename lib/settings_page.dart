import 'imports/imports.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreatorsList(),
            const Text(
              'Quantidade de Imagens:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ImageCountInput(
              controller: _imageCountController,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCountInput extends StatelessWidget {
  final TextEditingController controller;

  const ImageCountInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              errorText: _validateInput(controller.text),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_validateInput(controller.text) == null) {
              Navigator.pop(context, int.parse(controller.text));
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  String? _validateInput(String value) {
    final number = int.tryParse(value);
    if (number == null || number < 1 || number > 20) {
      return 'Opa! Valor inválido.';
    }
    return null;
  }
}

class CreatorsList extends StatelessWidget {
  const CreatorsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Criadores:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Luis Henrique Sousa Brasil'),
        Text('Laércio'),
        Text('Laércio'),
        SizedBox(height: 16),
      ],
    );
  }
}
