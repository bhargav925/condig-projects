import 'package:flutter/material.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/PIN SET/forgot_pin.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class VerifyPinScreen extends StatefulWidget {
  const VerifyPinScreen({super.key});

  @override
  State<VerifyPinScreen> createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends State<VerifyPinScreen> {
  String _pin = '';
  bool _isLoading = false;
  String _errorText = '';
  int _attempts = 0;

  void _addDigit(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
        if (_pin.length == 4) {
          _verifyPin();
        }
      });
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _resetPin() {
    setState(() {
      _pin = '';
      _errorText = '';
    });
  }

  void _verifyPin() async {
    if (_pin.isEmpty) {
      setState(() {
        _errorText = 'Please enter your PIN';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedPin = prefs.getString('app_pin');

      if (_pin == storedPin) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen(isLoggedIn: true, isPinSetup: true)),
          );
        }
      } else {
        _attempts++;
        if (_attempts >= 3) {
          // Reset login state after 3 failed attempts
          await prefs.setBool('isLoggedIn', false);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          setState(() {
            _errorText = 'Incorrect PIN. ${3 - _attempts} attempts remaining';
            _pin = '';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorText = 'Error verifying PIN';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleForgotPin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPinScreen()),
    );
  }

  Widget _buildPinDot(bool filled) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? Colors.blue : Colors.transparent,
        border: Border.all(color: Colors.blue, width: 2),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : () => _addDigit(number),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
            backgroundColor: Colors.white,
            elevation: 2,
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verify PIN'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter your PIN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your PIN to access the app',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return _buildPinDot(index < _pin.length);
                    }),
                  ),
                  if (_errorText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorText,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      _buildNumberButton('1'),
                      _buildNumberButton('2'),
                      _buildNumberButton('3'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildNumberButton('4'),
                      _buildNumberButton('5'),
                      _buildNumberButton('6'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildNumberButton('7'),
                      _buildNumberButton('8'),
                      _buildNumberButton('9'),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: _resetPin,
                            icon: const Icon(Icons.refresh, color: Colors.blue),
                          ),
                        ),
                      ),
                      _buildNumberButton('0'),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: _removeDigit,
                            icon: const Icon(
                              Icons.backspace,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: _handleForgotPin,
              child: const Text(
                'Forgot PIN?',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
