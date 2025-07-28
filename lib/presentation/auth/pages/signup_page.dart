import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:burki_book/presentation/auth/pages/signin_page.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool usePhone = false;
  bool showParrain = false;
  bool acceptCGU = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController parrainController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    parrainController.dispose();
    super.dispose();
  }

  void _signUpWithPhone() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;
    final generatedOtp = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000))
        .toString(); // OTP 4 chiffres
    // Simuler un loading avant navigation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
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
                  child: Image.asset(
                    'assets/logo_animer.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Création de votre compte',
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
                  'Merci de patienter pendant la création de votre compte Burki Book.',
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
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(
      '/otp_verification',
      arguments: {'phoneNumber': phone, 'generatedOtp': generatedOtp},
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
                    'assets/icons/signup.svg',
                    height: 64,
                    key: const Key('signup_hero_icon'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Créer un compte',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rejoignez la communauté Burki Book',
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
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom complet',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Champ obligatoire'
                        : null,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: showParrain,
                        onChanged: (v) =>
                            setState(() => showParrain = v ?? false),
                        activeColor: Color(0xFFFFD600),
                      ),
                      Text('J’ai un code parrain'),
                    ],
                  ),
                  if (showParrain)
                    TextFormField(
                      controller: parrainController,
                      decoration: InputDecoration(
                        labelText: 'Code parrain (optionnel)',
                        prefixIcon: Icon(Icons.card_giftcard_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: acceptCGU,
                        onChanged: (v) =>
                            setState(() => acceptCGU = v ?? false),
                        activeColor: Color(0xFF388E3C),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text.rich(
                            TextSpan(
                              text: "J'accepte les ",
                              children: [
                                TextSpan(
                                  text: 'CGU',
                                  style: TextStyle(
                                    color: Color(0xFFD32F2F),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' et la '),
                                TextSpan(
                                  text: 'politique de confidentialité',
                                  style: TextStyle(
                                    color: Color(0xFFD32F2F),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
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
                      onPressed: acceptCGU
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                if (usePhone) {
                                  _signUpWithPhone();
                                } else {
                                  // TODO: Inscription classique email
                                }
                              }
                            }
                          : null,
                      child: Text(
                        "S’inscrire",
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
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 700),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignInPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: Hero(
                                    tag: 'auth_hero_icon',
                                    child: child,
                                  ),
                                );
                              },
                        ),
                      );
                    },
                    child: Text(
                      'Vous avez déjà un compte ? Connectez-vous',
                      style: TextStyle(color: Color(0xFFD32F2F)),
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
