import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const BuscadorDeUsuariosApp());
}

class BuscadorDeUsuariosApp extends StatelessWidget {
  const BuscadorDeUsuariosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscador de Usuários',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      home: const UserFinderPage(),
    );
  }
}

class UserFinderPage extends StatefulWidget {
  const UserFinderPage({super.key});

  @override
  _UserFinderPageState createState() => _UserFinderPageState();
}

class _UserFinderPageState extends State<UserFinderPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String? _name;
  String? _email;
  String? _avatarUrl;
  String? _error;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _name = null;
      _email = null;
      _avatarUrl = null;
    });

    final id = _controller.text.trim();

    if (id.isEmpty || int.tryParse(id) == null || int.parse(id) < 1 || int.parse(id) > 12) {
      setState(() {
        _error = 'Insira um ID válido (1 a 12)!';
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('https://reqres.in/api/users/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['data'];

        setState(() {
          _name = '${user['first_name']} ${user['last_name']}';
          _email = user['email'];
          _avatarUrl = user['avatar'];
          _error = null;
        });
        _animationController.forward(from: 0.0);
      } else {
        setState(() {
          _error = 'Usuário não encontrado!';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao conectar: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showUserDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.network(
                    _avatarUrl!,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _name!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.purpleAccent,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _email!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.purpleAccent, Colors.cyanAccent],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Fechar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212),
              Color(0xFF1E1E1E),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Buscador de Usuários',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.purpleAccent,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Digite o ID (1-12)',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    prefixIcon: const Icon(Icons.search, color: Colors.purpleAccent),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _isLoading ? null : _fetchUser,
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.purpleAccent, Colors.cyanAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Buscar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.purpleAccent,
                            ),
                          )
                        : _error != null
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : _name != null && _email != null && _avatarUrl != null
                                ? GestureDetector(
                                    onTap: () => _showUserDetails(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(60),
                                            child: Image.network(
                                              _avatarUrl!,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            _name!,
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            _email!,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}