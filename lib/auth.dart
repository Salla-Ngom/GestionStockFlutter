import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer'; 
import '../vues/home.dart';
import '../vues/admin_page.dart';
import '../vues/page_connexion.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

 Future<void> signInWithEmailAndPassword({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        final role = data['role'];
        final actif = data['actif'];

        if (!context.mounted) return; 

        if (actif == true) {
          if (role == 'Utilisateur') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          } else if (role == 'Admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rôle utilisateur non pris en charge.')),
            );
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PageConnexion()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Votre compte est désactivé.')),
          );
           Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PageConnexion()),
            );
        }
      } else {
        if (!context.mounted) return; 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Votre compte n\'existe pas!')),
        );
         Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PageConnexion()),
            );
      }
    }
  } catch (e) {
    if (!context.mounted) return; 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('informations Incorrectes!.')),
    );
     Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PageConnexion()),
            );
  }
}


  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log('Erreur lors de la déconnexion : $e', error: e);
    }
  }
}
