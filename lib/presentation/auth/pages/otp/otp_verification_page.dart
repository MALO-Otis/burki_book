import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:burki_book/presentation/common/loading_data_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String generatedOtp;
  final bool fromLogin;
  const OtpVerificationPage({
    Key? key,
    required this.phoneNumber,
    required this.generatedOtp,
    this.fromLogin = false,
  }) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;
  List<String> otpDigits = List.filled(4, '');
  bool isVerified = false;
  int _seconds = 60;
  bool _canResend = false;
  late String _currentOtp;
  Timer? _timer;
  bool _isResending = false;
  String _resendStatus = '';

  String _generateOtp() {
    final rand = Random();
    return (1000 + rand.nextInt(9000)).toString();
  }

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(4, (_) => TextEditingController());
    otpFocusNodes = List.generate(4, (_) => FocusNode());
    _currentOtp = widget.generatedOtp.isNotEmpty
        ? widget.generatedOtp
        : _generateOtp();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOtpDialog();
      otpFocusNodes[0].requestFocus(); // Focus auto sur la 1ère case
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = 60;
    _canResend = false;
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

  void _resendOtp() async {
    print('[OTP] Bouton renvoyer cliqué');
    setState(() {
      _currentOtp = _generateOtp();
      print('[OTP] Nouveau code généré : ' + _currentOtp);
      for (var c in otpControllers) c.clear();
      otpDigits = List.filled(4, '');
      _startTimer();
    });
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      print('[OTP] Affichage du dialogue OTP');
      _showOtpDialog();
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFFF5F5F5),
        title: Row(
          children: [
            Icon(Icons.sms, color: Color(0xFF388E3C), size: 28),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Code OTP envoyé !',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_open_rounded, color: Color(0xFFD32F2F), size: 36),
            SizedBox(height: 10),
            Text(
              'Votre code de vérification :',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _currentOtp,
                style: TextStyle(
                  fontSize: 28,
                  letterSpacing: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Entrez ce code à 4 chiffres pour valider votre inscription.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyOtp() {
    if (otpDigits.join() == _currentOtp) {
      setState(() => isVerified = true);
      Get.to(() => LoadingDataPage());
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAllNamed('/home');
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('Erreur'),
            ],
          ),
          content: Text('Le code OTP est incorrect. Réessayez.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: Color(0xFFD32F2F))),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final c in otpControllers) c.dispose();
    for (final f in otpFocusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF388E3C)),
          onPressed: () {
            if (widget.fromLogin) {
              Navigator.of(context).pushReplacementNamed('/signin');
            } else {
              Navigator.of(context).pushReplacementNamed('/signup');
            }
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.sms_rounded, color: Color(0xFF388E3C), size: 64),
                const SizedBox(height: 12),
                Text(
                  'Vérification du code',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Un code à 4 chiffres a été envoyé à votre téléphone",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double boxWidth = (constraints.maxWidth - 60) / 4;
                    boxWidth = boxWidth.clamp(48, 64);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (i) => _buildOtpBox(i, boxWidth),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  _canResend
                      ? 'Code expiré'
                      : 'Code expire dans : ${_formatTimer(_seconds)}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD600),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed:
                        otpDigits.every((d) => d.isNotEmpty) && !_canResend
                        ? _verifyOtp
                        : null,
                    child: Text(
                      'Vérifier',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    side: BorderSide(color: Color(0xFFFFD600)),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _canResend ? _resendOtp : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: Color(0xFF388E3C), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Renvoyer le code',
                        style: TextStyle(
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_resendStatus.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _resendStatus,
                      style: TextStyle(
                        color: Color(0xFF388E3C),
                        fontWeight: FontWeight.bold,
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

  Widget _buildOtpBox(int index, double width) {
    return Container(
      width: width,
      height: width,
      margin: EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: otpFocusNodes[index].hasFocus
              ? Color(0xFF388E3C)
              : Colors.black26,
          width: 2.2,
        ),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          if (otpFocusNodes[index].hasFocus)
            BoxShadow(
              color: Color(0xFF388E3C).withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: otpControllers[index],
          focusNode: otpFocusNodes[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: width * 0.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            isCollapsed: false,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (val) {
            if (val.isNotEmpty) {
              otpDigits[index] = val;
              if (index < 3) {
                otpFocusNodes[index + 1].requestFocus();
              } else {
                otpFocusNodes[index].unfocus();
              }
            } else {
              otpDigits[index] = '';
              if (index > 0) {
                otpFocusNodes[index - 1].requestFocus();
              }
            }
            setState(() {});
          },
          onTap: () {
            otpControllers[index].selection = TextSelection(
              baseOffset: 0,
              extentOffset: otpControllers[index].text.length,
            );
          },
          onSubmitted: (_) {
            if (index == 3 && otpDigits.join() == _currentOtp) _verifyOtp();
          },
        ),
      ),
    );
  }

  String _formatTimer(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
