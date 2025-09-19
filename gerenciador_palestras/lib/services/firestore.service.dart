import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> get(CollectionReference collection) {
    final result = collection.snapshots();

    return result;
  }

  Future<void> delete(String id, CollectionReference collection) {
    return collection.doc(id).delete();
  }

  Future<DocumentSnapshot> getById(String id, CollectionReference collection) async {
    final doc = await collection.doc(id).get();
    return doc;
  }
}