import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AjoutVente extends StatelessWidget {
  const AjoutVente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: const AjoutVenteBody(),
      ),
    );
  }
}

class AjoutVenteBody extends StatefulWidget {
  const AjoutVenteBody({super.key});

  @override
  State<AjoutVenteBody> createState() => _AjoutVenteBodyState();
}

class _AjoutVenteBodyState extends State<AjoutVenteBody> {
  String? _selectedProduct;
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _nomClientController = TextEditingController();
  double _prixTotal = 0.0;
  final String _dateAujourdhui =
      DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

  @override
  void dispose() {
    _quantiteController.dispose();
    _nomClientController.dispose();
    super.dispose();
  }

  void _calculateTotalPrice(double pricePerUnit) {
    final quantite = int.tryParse(_quantiteController.text) ?? 0;
    setState(() {
      _prixTotal = quantite * pricePerUnit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Ajout Vente',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
              ),
            ),
          ),
          const SizedBox(height: 30),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('produits').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('Aucun produit disponible.');
              }

              final produits = snapshot.data!.docs;
              return DropdownButtonFormField<String>(
                value: _selectedProduct,
                decoration: const InputDecoration(
                  labelText: 'Sélectionnez un produit',
                  border: OutlineInputBorder(),
                ),
                items: produits.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final produitNom = data['nomProduit'];
                  final prixUnitaire = data['prix'] ?? 0.0;
                  return DropdownMenuItem<String>(
                    value: "${doc.id};$produitNom;$prixUnitaire",
                    child: Text(produitNom),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final parts = value.split(';');
                    final prixUnitaire = double.parse(parts[2]);
                    _selectedProduct = value;
                    _calculateTotalPrice(prixUnitaire);
                  }
                },
              );
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _quantiteController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantité',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (_selectedProduct != null) {
                final parts = _selectedProduct!.split(';');
                final prixUnitaire = double.parse(parts[2]);
                _calculateTotalPrice(prixUnitaire);
              }
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nomClientController,
            decoration: const InputDecoration(
              labelText: 'Nom complet du client',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              'Prix total : $_prixTotal FCFA',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              'Date : $_dateAujourdhui',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  if (_selectedProduct == null ||
                      _quantiteController.text.isEmpty ||
                      _nomClientController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez remplir tous les champs.'),
                      ),
                    );
                    return;
                  }
                  final parts = _selectedProduct!.split(';');
                  final produitId = parts[0];
                  final produitNom = parts[1];
                  final vente = {
                    'produitId': produitId,
                    'nomProduit': produitNom,
                    'quantite': int.parse(_quantiteController.text),
                    'nomClient': _nomClientController.text,
                    'prixTotal': _prixTotal,
                    'date': _dateAujourdhui,
                  };

                  try {
                    await FirebaseFirestore.instance
                        .collection('ventes')
                        .add(vente);

                    if (context.mounted) {
                      // Vérification si le widget est encore monté
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vente ajoutée avec succès')),
                      );
                    }

                    setState(() {
                      _selectedProduct = null;
                      _quantiteController.clear();
                      _nomClientController.clear();
                      _prixTotal = 0.0;
                    });
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Erreur lors de l\'ajout : $error')),
                      );
                    }
                  }
                },
                child: const Text(
                  'Ajouter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
