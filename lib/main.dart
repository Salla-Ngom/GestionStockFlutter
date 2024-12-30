import 'package:flutter/material.dart';
import 'vues/page_connexion.dart';
import 'package:firebase_core/firebase_core.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyBfk0tmaWQ9qizl-gm3nXyY6ehEmjes8dI",
  authDomain: "gestionstock-3349c.firebaseapp.com",
  projectId: "gestionstock-3349c",
  storageBucket: "gestionstock-3349c.firebasestorage.app",
  messagingSenderId: "370906353293",
  appId: "1:370906353293:web:06bfac80347b706e921cc4",
  measurementId: "G-TKJ0WGGTE4",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: firebaseConfig,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PageConnexion(),
    );
  }
}
