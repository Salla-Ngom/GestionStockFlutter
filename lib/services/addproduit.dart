import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; 
import '../models/produit.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduit(Produits produit) async {
    try {
      await _firestore.collection('produits').add({
        'nomProduit': produit.nomProduit,
        'description': produit.description,
        'quantite': produit.quantite,
        'prix': produit.prix,
      });
      debugPrint("Produit ajouté avec succès !");
    } catch (e) {
      debugPrint("Erreur lors de l'ajout du produit : $e");
      throw Exception("Erreur lors de l'ajout du produit");
    }
  }

  Future<void> modifierProduit(String docId, Produits produit) async {
    try {
      await _firestore.collection('produits').doc(docId).update({
        'nomProduit': produit.nomProduit,
        'description': produit.description,
        'quantite': produit.quantite,
        'prix': produit.prix,
      });
      debugPrint("Produit mis à jour avec succès !");
    } catch (e) {
      debugPrint("Erreur lors de la mise à jour du produit : $e");
      throw Exception("Erreur lors de la mise à jour du produit");
    }
  }

  Future<void> supprimerProduit(String docId) async {
    try {
      await _firestore.collection('produits').doc(docId).delete();
      debugPrint("Produit supprimé avec succès !");
    } catch (e) {
      debugPrint("Erreur lors de la suppression du produit : $e");
      throw Exception("Erreur lors de la suppression du produit");
    }
  }
}
