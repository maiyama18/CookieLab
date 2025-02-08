import 'package:cookielab/views/message_view.dart';
import 'package:flutter/material.dart';

import '../api_client.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool _isLoading = false;
  String _text = 'No message...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MessageView(),
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

  Future<void> _fetchMessage() async {
    setState(() => _isLoading = true);
    setState(() => _text = 'Loading...');
    try {
      final message = await ApiClient().fetchMessage();
      setState(() => _text = message);
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
