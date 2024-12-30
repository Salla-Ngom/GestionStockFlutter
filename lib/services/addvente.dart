import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vente.dart';

class FirestoreVente {
  final FirebaseFirestore _firestoreVente = FirebaseFirestore.instance;
  Future<void> addVente(Vente vente) async {
    try {
      await _firestoreVente.collection('ventes').add({
        'nomProduitVendu': vente.nomProduitVendu,
        'quantite': vente.quantite,
        'nomDuClient': vente.nomDuClient,
        'telephoneClient': vente.telephoneClient,
        'date': vente.date,
      });
    } catch (e) {
      print('');
    }
  }
}
