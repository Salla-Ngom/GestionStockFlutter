import 'package:flutter/material.dart';
import '../services/addproduit.dart';
import '../models/produit.dart';

class AjoutPage extends StatelessWidget {
  const AjoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const AjoutPageBody(),
    );
  }
}

class AjoutPageBody extends StatefulWidget {
  const AjoutPageBody({super.key});

  @override
  State<AjoutPageBody> createState() => _AjoutPageBodyState();
}

class _AjoutPageBodyState extends State<AjoutPageBody> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  void _ajouterProduit() {
    final String nomProduit = _nomController.text;
    final String description = _descriptionController.text;
    final int quantite = int.tryParse(_quantiteController.text) ?? 0;
    final int prix = int.tryParse(_prixController.text) ?? 0;

    if (nomProduit.isNotEmpty &&
        description.isNotEmpty &&
        quantite > 0 &&
        prix > 0) {
      final produit = Produits(nomProduit, description, quantite, prix);
      _firebaseService.addProduit(produit).then((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produit ajouté avec succès !')),
          );
          _nomController.clear();
          _descriptionController.clear();
          _quantiteController.clear();
          _prixController.clear();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
          child: Text(
            'Ajout Produits',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom produit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _quantiteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantité',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _prixController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Prix (en FCFA)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _ajouterProduit,
                child: const Text(
                  'Ajouter',
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
    );
  }
}
