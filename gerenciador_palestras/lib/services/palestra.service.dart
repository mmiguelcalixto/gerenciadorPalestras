import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciador_palestras/models/palestra.dart';

class PalestraService {
  final CollectionReference palestras = FirebaseFirestore.instance.collection("palestras");

  Future<Future<DocumentReference<Object?>>> addPalestra(Palestra palestra) async {
    return palestras.add({
      "titulo": palestra.titulo,
      "palestrante": palestra.palestrante,
      "vagasTotal": palestra.vagasTotal,
      "vagasDisponiveis": palestra.vagasDisponiveis,
    });
  }

  Future<void> updatePalestra(String id, Palestra palestra) {
    return palestras.doc(id).update({
      "titulo": palestra.titulo,
      "palestrante": palestra.palestrante,
      "vagasTotal": palestra.vagasTotal,
      "vagasDisponiveis": palestra.vagasDisponiveis,
    });
  }
}