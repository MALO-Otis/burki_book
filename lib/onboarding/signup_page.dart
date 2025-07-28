import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool usePhone = false;
  bool showParrain = false;
  bool acceptCGU = false;
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
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
                  SvgPicture.asset('assets/icons/signup.svg', height: 64),
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
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v == null || v.length < 6
                        ? '6 caractères minimum'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                                // TODO: Inscription
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
                      // TODO: Naviguer vers la page de connexion
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
