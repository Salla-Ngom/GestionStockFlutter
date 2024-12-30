class Users {
  String prenom;
  String nom;
  String email;
  String password;
  String tel;
  String adresse;
  String role;
  bool actif;

  Users({
    required this.prenom,
    required this.nom,
    required this.email,
    required this.password,
    required this.tel,
    required this.adresse,
    required this.role,
    required this.actif,
  });

  String get getPrenom => prenom;
  set setPrenom(String prenom) => this.prenom = prenom;

  String get getNom => nom;
  set setNom(String nom) => this.nom = nom;

  String get getEmail => email;
  set setEmail(String email) => this.email = email;

  String get getPassword => password;
  set setPassword(String password) => this.password = password;

  String get getTel => tel;
  set setTel(String tel) => this.tel = tel;

  String get getAdresse => adresse;
  set setAdresse(String adresse) => this.adresse = adresse;

  String get getRole => role;
  set setRole(String role) => this.role = role;

  bool get getActif => actif;
  set setActif(bool actif) => this.actif = actif;
}
