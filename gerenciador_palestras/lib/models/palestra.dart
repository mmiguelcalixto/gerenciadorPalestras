import 'package:cloud_firestore/cloud_firestore.dart';

class Palestra {
  final String id;
  final String titulo;
  final String palestrante;
  final int vagasTotal;
  int vagasDisponiveis;

  Palestra({
    required this.id,
    required this.titulo,
    required this.palestrante,
    required this.vagasTotal,
    required this.vagasDisponiveis,
  });

  factory Palestra.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Palestra(
      id: doc.id,
      titulo: data['titulo'] ?? 'Título Desconhecido',
      palestrante: data['palestrante'] ?? 'Palestrante Desconhecido',
      vagasTotal: data['vagasTotal'] ?? 0,
      vagasDisponiveis: data['vagasDisponiveis'] ?? 0,
    );
  }
}
