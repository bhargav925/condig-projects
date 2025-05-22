import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/PIN SET/setup_pin.dart';

class ForgotPinScreen extends StatefulWidget {
  const ForgotPinScreen({super.key});

  @override
  State<ForgotPinScreen> createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends State<ForgotPinScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _errorText = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString('user_email') ?? '';

      if (_emailController.text.trim() == storedEmail) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SetupPinScreen(isReset: true),
            ),
          );
        }
      } else {
        final emailDomain = storedEmail.split('@').length > 1 ? '@${storedEmail.split('@')[1]}' : '';
        setState(() {
          _errorText = 'Email does not match. Your registered email ends with $emailDomain';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot PIN'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Verify your email to reset your PIN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: const OutlineInputBorder(),
                errorText: _errorText.isNotEmpty ? _errorText : null,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyEmail,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Verify Email',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
