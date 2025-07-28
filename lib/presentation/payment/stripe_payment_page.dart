import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StripePaymentPage extends StatelessWidget {
  final String resume;
  final num montant;

  const StripePaymentPage({
    Key? key,
    required this.resume,
    required this.montant,
  }) : super(key: key);

  String formatFcfa(num value) {
    return NumberFormat('#,##0', 'fr_FR').format(value) + ' FCFA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement sécurisé'),
        backgroundColor: const Color(0xFFF57C00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Paiement 100% sécurisé par Stripe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Résumé de la commande',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(resume, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total à payer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  formatFcfa(montant),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Informations de carte',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Numéro de carte',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              maxLength: 19,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'MM/AA',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVC',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Bannière promo/slider (exemple simple)
            Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_offer, color: Colors.deepOrange, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Profitez de -30% sur votre premier achat avec le code BIENVENUE30',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF57C00),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Simuler le paiement
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Paiement réussi'),
                    content: const Text(
                      'Votre paiement a été accepté. Merci pour votre achat !',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back(result: true);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_score, color: Colors.white),
                  SizedBox(width: 8),
                  const Text(
                    'Payer maintenant',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
