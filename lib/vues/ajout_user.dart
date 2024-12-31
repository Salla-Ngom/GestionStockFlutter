import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/adduser.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  String prenom = '';
  String nom = '';
  String email = '';
  String password = '';
  String tel = '';
  String adresse = '';
  String role = 'Utilisateur';
  bool actif = true;
  bool isLoading = false;
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();

  final FirebaseUsers _firebaseUsers = FirebaseUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informations de l\'utilisateur',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'Prénom',
                      controller: _prenomController,
                      validator: (value) =>
                          value!.isEmpty ? 'Ce champ est requis' : null,
                    ),
                    _buildTextField(
                      label: 'Nom',
                      controller: _nomController,
                      validator: (value) =>
                          value!.isEmpty ? 'Ce champ est requis' : null,
                    ),
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty || !value.contains('@')
                              ? 'Email invalide'
                              : null,
                    ),
                    _buildTextField(
                      label: 'Mot de passe',
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Ce champ est requis' : null,
                    ),
                    _buildTextField(
                      label: 'Numéro de téléphone',
                      controller: _telController,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? 'Ce champ est requis' : null,
                    ),
                    _buildTextField(
                      label: 'Adresse',
                      controller: _adresseController,
                      validator: (value) =>
                          value!.isEmpty ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: InputDecoration(
                        labelText: 'Rôle',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.blue,
                      ),
                      items: ['Utilisateur', 'Admin']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                      onChanged: (newRole) {
                        setState(() {
                          role = newRole!;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Utilisateur Actif'),
                        Switch(
                          value: actif,
                          onChanged: (value) {
                            setState(() {
                              actif = value;
                            });
                          },
                          activeColor: Colors.blueAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                            )
                          : ElevatedButton(
                              onPressed: _ajouterUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.add, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Enregistrer',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.blue.withValues(alpha: (0.1 * 255)),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }

  void _ajouterUser() {
    final String prenom = _prenomController.text;
    final String nom = _nomController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String tel = _telController.text;
    final String adresse = _adresseController.text;

    if (prenom.isNotEmpty &&
        nom.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        tel.isNotEmpty &&
        adresse.isNotEmpty) {
      final user = Users(
        prenom: prenom,
        nom: nom,
        email: email,
        password: password,
        tel: tel,
        adresse: adresse,
        role: role,
        actif: actif,
      );

      _firebaseUsers.addUser(user).then((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Utilisateur ajouté avec succès !')),
          );
          _prenomController.clear();
          _nomController.clear();
          _emailController.clear();
          _passwordController.clear();
          _telController.clear();
          _adresseController.clear();
        }
      }).catchError((e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur : $e')),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
    }
  }
}
