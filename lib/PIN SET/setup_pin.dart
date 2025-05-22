import 'package:flutter/material.dart';
import 'package:chatapp/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class SetupPinScreen extends StatefulWidget {
  final bool isReset;
  const SetupPinScreen({super.key, this.isReset = false});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _isLoading = false;
  String _errorText = '';

  void _addDigit(String digit) {
    setState(() {
      if (!_isConfirming && _pin.length < 4) {
        _pin += digit;
        if (_pin.length == 4) {
          _isConfirming = true;
        }
      } else if (_isConfirming && _confirmPin.length < 4) {
        _confirmPin += digit;
        if (_confirmPin.length == 4) {
          _setupPin();
        }
      }
    });
  }

  void _removeDigit() {
    setState(() {
      if (_isConfirming && _confirmPin.isNotEmpty) {
        _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
      } else if (!_isConfirming && _pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _resetPin() {
    setState(() {
      if (_isConfirming) {
        _confirmPin = '';
        _isConfirming = false;
      }
      _pin = '';
      _errorText = '';
    });
  }

  void _setupPin() async {
    if (_pin != _confirmPin) {
      setState(() {
        _errorText = 'PINs do not match';
        _confirmPin = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_pin', _pin);
      await prefs.setBool('pin_setup', true);

      if (mounted) {
        if (widget.isReset) {
          // Show success dialog before navigating back to verify PIN screen
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('PIN Reset Successful'),
              content: const Text('Your PIN has been successfully reset. Please use your new PIN to log in.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/verify_pin',
                      (route) => false,
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen(isLoggedIn: true, isPinSetup: true)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorText = 'Error setting up PIN';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
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
        title: const Text('Setup PIN'),
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
                  Text(
                    _isConfirming ? 'Confirm your PIN' : 'Create your PIN',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isConfirming
                        ? 'Re-enter the PIN to confirm'
                        : 'Enter a 4-digit PIN to secure your app',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final currentPin = _isConfirming ? _confirmPin : _pin;
                      return _buildPinDot(index < currentPin.length);
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
          ],
        ),
      ),
    );
  }
}
