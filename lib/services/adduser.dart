import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../models/user.dart';
import 'package:flutter/foundation.dart'; 

class FirebaseUsers {
  final FirebaseFirestore _firestoreUser = FirebaseFirestore.instance;
   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> addUser(Users user) async {
  try {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );

    await _firestoreUser.collection('users').doc(userCredential.user?.uid).set({
      'prenom': user.prenom,
      'nom': user.nom,
      'email': user.email,
      'tel': user.tel,
      'adresse': user.adresse,
      'role': user.role,
      'actif': user.actif,
    });

  } catch (e) {
    debugPrint("Erreur lors de l'ajout de l'utilisateur: $e");
  }
}

}
