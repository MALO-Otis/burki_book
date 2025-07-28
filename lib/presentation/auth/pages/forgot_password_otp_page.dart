import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:burki_book/presentation/auth/pages/reset_password_page.dart';

class ForgotPasswordOtpPage extends StatefulWidget {
  final String? contact;
  final String? generatedOtp;
  final bool usePhone;
  const ForgotPasswordOtpPage({
    Key? key,
    this.contact,
    this.generatedOtp,
    this.usePhone = false,
  }) : super(key: key);

  @override
  State<ForgotPasswordOtpPage> createState() => _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  Timer? _timer;
  int _seconds = 60;
  bool _canResend = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int idx, String value) {
    if (value.length == 1 && idx < 3) {
      _focusNodes[idx + 1].requestFocus();
    }
    if (value.isEmpty && idx > 0) {
      _focusNodes[idx - 1].requestFocus();
    }
    setState(() {
      _errorText = null;
    });
  }

  void _validateOtp() {
    final enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp.length < 4) {
      setState(() {
        _errorText = 'Veuillez saisir le code complet';
      });
      return;
    }
    if (enteredOtp != widget.generatedOtp) {
      setState(() {
        _errorText = 'Code incorrect';
      });
      return;
    }
    // Loader avant navigation vers reset password
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF388E3C).withOpacity(0.08),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF388E3C), Color(0xFFFFD600)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Icon(Icons.verified, size: 64, color: Colors.white),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Code vérifié !',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF388E3C),
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  'Vous pouvez maintenant définir un nouveau mot de passe.',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Color(0xFFFFD600).withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF388E3C)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
      Get.off(
        () => ResetPasswordPage(
          contact: widget.contact,
          usePhone: widget.usePhone,
        ),
      );
    });
  }

  void _resendOtp() {
    setState(() {
      _otpControllers.forEach((c) => c.clear());
      _errorText = null;
      _canResend = false;
      _seconds = 60;
    });
    _startTimer();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Nouveau code envoyé !')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Vérification du code'),
        backgroundColor: Color(0xFFD32F2F),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.verified_user, size: 56, color: Color(0xFF388E3C)),
                const SizedBox(height: 16),
                Text(
                  'Entrez le code reçu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF388E3C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.usePhone
                      ? 'Un code a été envoyé à votre numéro\n${widget.contact ?? ''}'
                      : 'Un code a été envoyé à votre email\n${widget.contact ?? ''}',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) => _buildOtpBox(i)),
                ),
                if (_errorText != null) ...[
                  SizedBox(height: 12),
                  Text(_errorText!, style: TextStyle(color: Colors.red)),
                ],
                SizedBox(height: 24),
                _canResend
                    ? TextButton.icon(
                        onPressed: _resendOtp,
                        icon: Icon(Icons.refresh, color: Color(0xFFD32F2F)),
                        label: Text(
                          'Renvoyer le code',
                          style: TextStyle(color: Color(0xFFD32F2F)),
                        ),
                      )
                    : Text(
                        'Renvoyer dans $_seconds s',
                        style: TextStyle(color: Colors.black45),
                      ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF388E3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _validateOtp,
                    child: Text(
                      "Vérifier",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildOtpBox(int idx) {
    return Container(
      width: 48,
      margin: EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        controller: _otpControllers[idx],
        focusNode: _focusNodes[idx],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD32F2F),
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Color(0xFFFFF8E1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
          ),
        ),
        onChanged: (v) => _onOtpChanged(idx, v),
      ),
    );
  }
}
