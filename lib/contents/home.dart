import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static const routeName = 'home';

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final shouldPop = await showExitConfirmationDialog(context);
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          color: const Color(0xFF8B83FA),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'encrypt');
                },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(
                        horizontal: width / 3, vertical: height / 50),
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    const Color(0xFF6860D7),
                  ),
                ),
                child: const Text(
                  'Encrypt',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: height / 3),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'decrypt');
                },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(
                        horizontal: width / 3, vertical: height / 50),
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    const Color(0xFF6860D7),
                  ),
                ),
                child: const Text(
                  'Decrypt',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
