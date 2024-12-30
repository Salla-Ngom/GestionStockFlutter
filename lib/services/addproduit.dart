import 'package:cloud_firestore/cloud_firestore.dart';
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
      print("Produit ajouté avec succès !");
    } catch (e) {
      print("Erreur lors de l'ajout du produit : $e");
    }
  }

  Future<void> modifierProduit(String docId, Produits produit) async {
    try {
      await _firestore.collection('produits').doc(docId).update({
        'nomProduit': produit.nomProduit,
        'description': produit.description,
        'quantite': produit.quantite,
      });
      print("Produit mis à jour avec succès !");
    } catch (e) {
      print("Erreur lors de la mise à jour du produit : $e");
      throw Exception("Erreur lors de la mise à jour du produit");
    }
  }

  Future<void> supprimerProduit(String docId) async {
    try {
      await _firestore.collection('produits').doc(docId).delete();
      print("Produit supprimé avec succès !");
    } catch (e) {
      print("Erreur lors de la suppression du produit : $e");
      throw Exception("Erreur lors de la suppression du produit");
    }
  }
}
