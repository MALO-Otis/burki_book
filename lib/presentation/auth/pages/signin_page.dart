import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:burki_book/presentation/auth/pages/signup_page.dart';
import 'package:burki_book/presentation/auth/pages/forgot_password_page.dart';
import 'package:burki_book/presentation/auth/pages/otp/otp_verification_page.dart';
import 'package:get/get.dart';
import 'package:burki_book/presentation/common/loading_data_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool usePhone = false;
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _loginWithPhone() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;
    final generatedOtp = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000))
        .toString();
    // Simuler un loading avant navigation
    Get.dialog(
      Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F))),
      barrierDismissible: false,
    );
    await Future.delayed(const Duration(seconds: 3));
    Get.back();
    Get.to(
      () => OtpVerificationPage(
        phoneNumber: phone,
        generatedOtp: generatedOtp,
        fromLogin: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                  SvgPicture.asset(
                    'assets/icons/signin.svg',
                    height: 64,
                    key: const Key('signin_hero_icon'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connectez-vous à votre compte Burki Book',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Champ obligatoire'
                          : null,
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
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
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => ForgotPasswordPage());
                      },
                      child: Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(color: Color(0xFF388E3C)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Color(0xFF388E3C),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (usePhone) {
                            _loginWithPhone();
                          } else {
                            // Simulation connexion email
                            Get.to(() => LoadingDataPage());
                            Future.delayed(const Duration(seconds: 3), () {
                              Get.offAllNamed('/home');
                            });
                          }
                        }
                      },
                      child: Text(
                        "Se connecter",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Get.off(
                        () => SignUpPage(),
                        transition: Transition.fadeIn,
                        duration: Duration(milliseconds: 700),
                      );
                    },
                    child: Text(
                      'Pas encore de compte ? Inscrivez-vous',
                      style: TextStyle(color: Color(0xFF388E3C)),
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
