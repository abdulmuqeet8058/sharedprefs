import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Preferences',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: PreferencesScreen(),
    );
  }
}

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _selectedTheme = "Light";

  Future<void> _savePreferences() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a username!")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('theme', _selectedTheme);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Preferences saved!")),
    );
  }

  Future<void> _navigateToViewPreferences() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewPreferencesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save Preferences"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              items: ["Light", "Dark"]
                  .map((theme) => DropdownMenuItem(
                        value: theme,
                        child: Text(theme),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Theme",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePreferences,
              child: const Text("Save Preferences"),
            ),
            ElevatedButton(
              onPressed: _navigateToViewPreferences,
              child: const Text("View Preferences"),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewPreferencesScreen extends StatefulWidget {
  @override
  _ViewPreferencesScreenState createState() => _ViewPreferencesScreenState();
}

class _ViewPreferencesScreenState extends State<ViewPreferencesScreen> {
  String? _username;
  String? _theme;

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _theme = prefs.getString('theme');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Preferences"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Username: ${_username ?? "Not Set"}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(
                "Preferred Theme: ${_theme ?? "Not Set"}",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
