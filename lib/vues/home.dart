import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ajout_produit.dart';
import 'ajout_vente.dart';
import '../auth.dart';
import 'page_connexion.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GESTION STOCK',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(child:const HomePage(),),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(), 
    const AjoutPage(),   
    const AjoutVente(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Ajout Produit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Ajout Vente',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});
  void _afficherDetailsVente(
      BuildContext context, Map<String, dynamic> venteData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Détails de la Vente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom Client : ${venteData['nomClient'] ?? 'Non spécifié'}'),
              Text('Produit : ${venteData['nomProduit'] ?? 'Non spécifié'}'),
              Text('Quantité : ${venteData['quantite'] ?? 'Non spécifié'}'),
              Text('Prix Total : ${venteData['prixTotal'] ?? 'Non spécifié'}'),
              Text('Date : ${venteData['date'] ?? 'Non spécifié'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('produits').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> produitSnapshot) {
        if (produitSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!produitSnapshot.hasData || produitSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Aucun produit trouvé.'));
        }

        final produits = produitSnapshot.data!.docs;
        final nombreArticles = produits.length;
        final quantiteMin = produits.isNotEmpty
            ? produits
                .map((doc) => doc['quantite'] ?? 0)
                .reduce((a, b) => a < b ? a : b)
            : 0;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Bienvenue(e): Moussa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                       
                    ],
                  ),
                 IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                            100.0, 100.0, 0.0, 0.0),
                        items: [
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Text(
                              'Déconnexion',
                              style: TextStyle(
                                  color: Colors.red),
                            ),
                            onTap: () async {
                              final Auth _auth = Auth();
                              await _auth.signOut(); 
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PageConnexion()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoCard(
                    title: 'Articles',
                    value: '$nombreArticles', 
                    color: Colors.teal,
                  ),
                  InfoCard(
                    title: 'Stock Min',
                    value: '$quantiteMin kg', 
                    color: Colors.red,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('ventes').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> venteSnapshot) {
                      if (venteSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final nombreVentes = venteSnapshot.data?.docs.length ?? 0;
                      return InfoCard(
                        title: 'Total Ventes',
                        value: '$nombreVentes',
                        color: Colors.green,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Produits en Stock',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: produits.length,
                  itemBuilder: (context, index) {
                    final produitData = produits[index].data() as Map<String, dynamic>;
                    final docId = produits[index].id;
                    final nomProduit = produitData['nomProduit'] ?? 'Nom inconnu';

                    return Card(
                      child: ListTile(
                        title: Text(
                          nomProduit,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info, color: Colors.blue),
                              onPressed: () {
                                _afficherDetails(context, produitData);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  await FirebaseService().supprimerProduit(docId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Produit supprimé.')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erreur : $e')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ventes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('ventes').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Aucune vente trouvée.'));
                  }

                  final ventes = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ventes.length,
                    itemBuilder: (context, index) {
                      final venteData =
                          ventes[index].data() as Map<String, dynamic>;
                      final docId = ventes[index].id; 
                      final nomClient = venteData['nomClient'] ?? 'Nom inconnu';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             
                              Text(
                                'ID Vente : $docId',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              Text(
                                'Client : $nomClient',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    
                                    _afficherDetailsVente(context, venteData);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    'Voir détails',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _afficherDetails(BuildContext context, Map<String, dynamic> produitData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(produitData['nomProduit'] ?? 'Détails du produit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description: ${produitData['description'] ?? 'Aucune'}'),
              Text('Quantité: ${produitData['quantite'] ?? 0}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const InfoCard({
    required this.title,
    required this.value,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseService {
  Future<void> supprimerProduit(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('produits').doc(docId).delete();
    } catch (e) {
      throw Exception('Erreur de suppression du produit: $e');
    }
  }
}
