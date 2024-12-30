class Vente {
  String nomProduitVendu;
  String nomDuClient;
  String telephoneClient;
  String date;
  int quantite;
  Vente(this.nomProduitVendu, this.quantite, this.nomDuClient,
      this.telephoneClient, this.date);
  String get getNomDuClient => nomDuClient;

  set setNomDuClient(String nomDuClient) => this.nomDuClient = nomDuClient;
  String get getNomProduitVendu => nomProduitVendu;
  set setNomProduitVendu(String nomProduitVendu) =>
      this.nomProduitVendu = nomProduitVendu;
  String get getTelephoneClient => telephoneClient;
  set setTelephoneClient(String telephoneClient) =>
      this.telephoneClient = telephoneClient;
  int get getQuantite => quantite;
  set setQuantite(int quantite) => this.quantite = quantite;
}
