import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';

class User {

  User({this.email, this.password, this.name, this.id});

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data["name"] as String;
    email = document.data["email"] as String;
    cpf = document.data["cpf"] as String;
    if(document.data.containsKey("address")){
      address = Address.fromMap(
          document.data["address"] as Map<String, dynamic>);
    }
  }

  String id;
  String email;
  String name;
  String password;
  String cpf;

  String confirmPassword;

  bool admin = false;

  Address address;

  DocumentReference get firestoreRef =>
    Firestore.instance.document('users/$id');

  CollectionReference get cartRef =>
    firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "email": email,
      if(address != null)
        "address": address.toMap(),
      if(cpf != null)
        "cpf": cpf,
    };
  }

  Future<void> setAddress(Address address) async {
    this.address = address;
    saveData();
  }

  void setCpf(String cpf){
    this.cpf = cpf;
    saveData();
  }

}