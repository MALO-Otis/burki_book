import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:burki_book/presentation/auth/pages/forgot_password_otp_page.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool usePhone = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      final otp = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000))
          .toString();
      Get.dialog(
        Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F))),
        barrierDismissible: false,
      );
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
        Get.to(
          () => ForgotPasswordOtpPage(
            contact: usePhone
                ? phoneController.text.trim()
                : emailController.text.trim(),
            generatedOtp: otp,
            usePhone: usePhone,
          ),
        );
        // Affiche un dialog d'envoi OTP comme dans OTP verification
        Future.delayed(const Duration(milliseconds: 400), () {
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
                      color: Color(0xFFD32F2F).withOpacity(0.08),
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
                          colors: [Color(0xFFD32F2F), Color(0xFFFFD600)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Icon(Icons.sms, size: 64, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Code envoyé !',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFFD32F2F),
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        children: [
                          Text(
                            usePhone
                                ? 'Le code a été envoyé à votre numéro.'
                                : 'Le code a été envoyé à votre email.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFF8E1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xFFD32F2F)),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      otp,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFD32F2F),
                                        letterSpacing: 4,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: Color(0xFFD32F2F),
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(text: otp),
                                        );
                                        Get.snackbar(
                                          'Code copié',
                                          'Le code a été copié dans le presse-papier',
                                          backgroundColor: Colors.white,
                                          colorText: Color(0xFFD32F2F),
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor: Color(0xFFFFD600).withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFD32F2F),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
          Future.delayed(const Duration(seconds: 3), () {
            Get.back();
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Mot de passe oublié'),
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.lock_reset, size: 56, color: Color(0xFFD32F2F)),
                  const SizedBox(height: 16),
                  Text(
                    'Réinitialiser le mot de passe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Entrez votre email ou numéro de téléphone pour recevoir un code de réinitialisation.',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Row(
                          children: [
                            Icon(Icons.email, size: 18),
                            SizedBox(width: 4),
                            Text('Email'),
                          ],
                        ),
                        selected: !usePhone,
                        onSelected: (v) => setState(() => usePhone = false),
                        selectedColor: Color(0xFF388E3C).withOpacity(0.15),
                        backgroundColor: Colors.grey[200],
                      ),
                      SizedBox(width: 12),
                      ChoiceChip(
                        label: Row(
                          children: [
                            Icon(Icons.phone, size: 18),
                            SizedBox(width: 4),
                            Text('Téléphone'),
                          ],
                        ),
                        selected: usePhone,
                        onSelected: (v) => setState(() => usePhone = true),
                        selectedColor: Color(0xFFD32F2F).withOpacity(0.15),
                        backgroundColor: Colors.grey[200],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (!usePhone)
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Adresse email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Champ obligatoire';
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(v))
                          return 'Email invalide';
                        return null;
                      },
                    ),
                  if (usePhone)
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Champ obligatoire'
                          : null,
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD32F2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _sendOtp,
                      child: Text(
                        "Envoyer le code",
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
      ),
    );
  }
}
