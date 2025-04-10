import 'package:flutter/material.dart';
import 'gradient_button.dart';

class UserDetailsDialog extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;
  final VoidCallback onReset;

  const UserDetailsDialog({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
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
                avatarUrl,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.purpleAccent, blurRadius: 10, offset: Offset(0, 2)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: TextStyle(fontSize: 18, color: Colors.grey[400], fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                  text: 'Novo',
                  onTap: () {
                    Navigator.of(context).pop();
                    onReset();
                  },
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
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
          ],
        ),
      ),
    );
  }
}