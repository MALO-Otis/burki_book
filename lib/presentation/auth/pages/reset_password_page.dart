import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:burki_book/presentation/auth/pages/signin_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? contact;
  final bool usePhone;
  const ResetPasswordPage({Key? key, this.contact, this.usePhone = false})
    : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
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
                    child: Icon(Icons.lock_open, size: 64, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Mot de passe réinitialisé !',
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
                    'Votre mot de passe a été modifié avec succès. Vous pouvez maintenant vous connecter.',
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
      );
      await Future.delayed(const Duration(seconds: 3));
      Get.back();
      Get.offAll(() => SignInPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Nouveau mot de passe'),
        backgroundColor: Color(0xFF388E3C),
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
                  Icon(Icons.lock_reset, size: 56, color: Color(0xFF388E3C)),
                  const SizedBox(height: 16),
                  Text(
                    'Définir un nouveau mot de passe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Votre nouveau mot de passe doit contenir au moins 6 caractères.',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: 'Nouveau mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                    ),
                    validator: (v) => v == null || v.length < 6
                        ? '6 caractères minimum'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !showConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(
                          () => showConfirmPassword = !showConfirmPassword,
                        ),
                      ),
                    ),
                    validator: (v) => v != passwordController.text
                        ? 'Les mots de passe ne correspondent pas'
                        : null,
                  ),
                  const SizedBox(height: 24),
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
                      onPressed: _resetPassword,
                      child: Text(
                        "Valider",
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
