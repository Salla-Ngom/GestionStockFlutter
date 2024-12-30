class Produits {
  String nomProduit;
  String description;
  int quantite;
  int prix;

  Produits(this.nomProduit, this.description, this.quantite, this.prix);

  String get getNomProduit => nomProduit;
  set setNomProduit(String nomProduit) => this.nomProduit = nomProduit;

  String get getDescription => description;
  set setDescription(String description) => this.description = description;

  int get getQuantite => quantite;
  set setQuantite(int quantite) => this.quantite = quantite;

  int get getPrix => prix;
  set setPrix(int prix) => this.prix = prix;

  Map<String, dynamic> toMap() {
    return {
      'nomProduit': nomProduit,
      'description': description,
      'quantite': quantite,
      'prix': prix,
    };
  }
}
