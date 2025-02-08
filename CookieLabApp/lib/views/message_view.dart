import 'package:flutter/material.dart';

import '../api_client.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  String _text = 'No message...';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_text),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _fetchMessage,
          icon: SizedBox(
            width: 20,
            height: 20,
            child: _isLoading ? CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ) : Icon(Icons.message),
          ),
          label: Text('Get Message', style: const TextStyle(fontSize: 16)),
        ),
      ],
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
      setState(() => _text = 'No message...');
    } catch (e) {
      _showError('予期せぬエラーが発生しました');
      setState(() => _text = 'No message...');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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

