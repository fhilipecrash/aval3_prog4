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

class ImageCountInput extends StatefulWidget {
  final TextEditingController controller;

  const ImageCountInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  createState() => _ImageCountInputState();
}

class _ImageCountInputState extends State<ImageCountInput> {
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              setState(() {
                _showError = _validateInput(value) != null;
              });
            },
            decoration: InputDecoration(
              errorText:
                  _showError ? _validateInput(widget.controller.text) : null,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_validateInput(widget.controller.text) == null) {
              Navigator.pop(context, int.parse(widget.controller.text));
            }
          },
          child: const Text(
            'Salvar',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  String? _validateInput(String value) {
    final number = int.tryParse(value);
    if (number == null || number < 1 || number > 20) {
      return 'Opa! Valor inválido. Escolha entre 1 e 20.';
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
        Text('Laercio Souza da Silva'),
        Text('José Fhilipe Martins Coelho'),
        SizedBox(height: 16),
      ],
    );
  }
}
