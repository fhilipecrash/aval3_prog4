import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _textEditingController;
  int _selectedImageCount = 10;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '$_selectedImageCount');
  }

  void _saveSettings() {
    final enteredValue = int.tryParse(_textEditingController.text);
    setState(() {
      _selectedImageCount = enteredValue ?? 10;
    });
    Navigator.pop(context, _selectedImageCount);
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
          children: [
            const Text(
              'Criadores:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Luis Henrique Sousa Brasil'),
            const Text('Ciclano'),
            const SizedBox(height: 20),
            const Text(
              'Quantidade de imagens:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quantidade',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saveSettings,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
