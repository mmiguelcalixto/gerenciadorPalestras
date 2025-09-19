import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/estudante.dart';
import '../models/palestra.dart';

class PalestraService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getDocument(String collection, String id) {
    return _db.collection(collection).doc(id).get();
  }

  Future<void> updateDocument(String collection, String id, Map<String, dynamic> data) {
    return _db.collection(collection).doc(id).update(data);
  }

  Future<void> register(String estudanteId, Palestra palestra) async {
    final estudanteDoc = _db.collection('estudantes').doc(estudanteId);
    final palestraDoc = _db.collection('palestras').doc(palestra.id);

    return _db.runTransaction((transaction) async {
      final freshEstudanteDoc = await transaction.get(estudanteDoc);
      final freshPalestraDoc = await transaction.get(palestraDoc);

      final freshEstudante = Estudante.fromFirestore(freshEstudanteDoc);
      final freshPalestra = Palestra.fromFirestore(freshPalestraDoc);

      if (freshPalestra.vagasDisponiveis > 0 && freshEstudante.palestrasInscritas.length < 2) {
        transaction.update(estudanteDoc, {
          'palestrasInscritas': FieldValue.arrayUnion([palestra.id])
        });
        transaction.update(palestraDoc, {
          'vagasDisponiveis': freshPalestra.vagasDisponiveis - 1
        });
      } else {
        throw Exception('Inscrição não permitida. Verifique as vagas ou o limite de inscrições.');
      }
    });
  }

  Future<void> unregister(String estudanteId, Palestra palestra) async {
    final estudanteDoc = _db.collection('estudantes').doc(estudanteId);
    final palestraDoc = _db.collection('palestras').doc(palestra.id);

    return _db.runTransaction((transaction) async {
      final freshEstudanteDoc = await transaction.get(estudanteDoc);
      final freshPalestraDoc = await transaction.get(palestraDoc);

      final freshEstudante = Estudante.fromFirestore(freshEstudanteDoc);
      final freshPalestra = Palestra.fromFirestore(freshPalestraDoc);

      if (freshEstudante.palestrasInscritas.contains(palestra.id)) {
        transaction.update(estudanteDoc, {
          'palestrasInscritas': FieldValue.arrayRemove([palestra.id])
        });
        transaction.update(palestraDoc, {
          'vagasDisponiveis': freshPalestra.vagasDisponiveis + 1
        });
      }
    });
  }
}
