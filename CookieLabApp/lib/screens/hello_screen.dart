import 'package:flutter/material.dart';

import '../api_client.dart';

class HelloScreen extends StatefulWidget {
  const HelloScreen({super.key});

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  bool _isLoading = false;
  String _text = 'Not loaded';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_text),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchHelloMessage,
                icon: SizedBox(
                  width: 20,
                  height: 20,
                  child: _isLoading ? CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ) : Icon(Icons.message),
                ),
                label: Text('Hello', style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _logout,
                icon: SizedBox(
                  width: 20,
                  height: 20,
                  child: _isLoading ? CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ) : Icon(Icons.logout),
                ),
                label: Text('Logout', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        )
      )
    );
  }

  Future<void> _fetchHelloMessage() async {
    setState(() => _isLoading = true);
    setState(() => _text = 'Loading...');
    try {
      final helloMessage = await ApiClient().fetchHelloMessage();
      setState(() => _text = helloMessage);
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('予期せぬエラーが発生しました');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      await ApiClient().logout();
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('予期せぬエラーが発生しました');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pop();
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
