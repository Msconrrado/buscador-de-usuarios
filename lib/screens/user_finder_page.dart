import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/search_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/user_card.dart';
import '../widgets/user_details_dialog.dart';

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
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
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
        _error = 'Usuário não encontrado!';
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('https://reqres.in/api/users/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _name = '${data['first_name']} ${data['last_name']}';
          _email = data['email'];
          _avatarUrl = data['avatar'];
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

  void _resetSearch() {
    setState(() {
      _name = null;
      _email = null;
      _avatarUrl = null;
      _error = null;
      _controller.clear();
      _animationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
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
                      Shadow(color: Colors.purpleAccent, blurRadius: 10, offset: Offset(0, 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SearchField(controller: _controller),
                const SizedBox(height: 20),
                GradientButton(
                  text: 'Buscar',
                  onTap: _isLoading ? null : _fetchUser,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Center(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.purpleAccent)
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
                                  ? UserCard(
                                      name: _name!,
                                      email: _email!,
                                      avatarUrl: _avatarUrl!,
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (_) => UserDetailsDialog(
                                          name: _name!,
                                          email: _email!,
                                          avatarUrl: _avatarUrl!,
                                          onReset: _resetSearch,
                                        ),
                                      ),
                                      onReset: _resetSearch,
                                    )
                                  : const SizedBox.shrink(),
                    ),
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