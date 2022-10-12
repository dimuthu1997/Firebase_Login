import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasetest/services/auth_service.dart';

class CloudFirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool addProduct(String name, String price, int quantity, String imageUrl) {
    Map<String, dynamic> productData = {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
    try {
      if (AuthService().getCurrentUserId() != null) {
        CollectionReference collectionReference =
            firestore.collection(AuthService().getCurrentUserId() ?? "");

        collectionReference.add(productData);
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
    return false;
  }

  bool updateProduct(String documentId, String name, String price, int quantity,
      String imageUrl) {
    Map<String, dynamic> productData = {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
    try {
      if (AuthService().getCurrentUserId() != null) {
        CollectionReference collectionReference =
            firestore.collection(AuthService().getCurrentUserId() ?? "");

        collectionReference.doc(documentId).update(productData);

        return true;
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
    return false;
  }

  bool deleteProduct(String documentId) {
    try {
      firestore
          .collection(AuthService().getCurrentUserId() ?? "")
          .doc(documentId)
          .delete();
    } on FirebaseException catch (e) {
      print(e);
    }
    return false;
  }
}
