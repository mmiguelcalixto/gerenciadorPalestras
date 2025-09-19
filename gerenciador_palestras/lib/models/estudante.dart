import 'package:cloud_firestore/cloud_firestore.dart';

class Estudante {
  String id;
  String nome;
  String turma;
  String matricula;
  List<String> palestrasInscritas;

  Estudante({
    required this.id,
    required this.nome,
    required this.turma,
    required this.matricula,
    this.palestrasInscritas = const [],
  });

  factory Estudante.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final palestrasInscritasData = data['palestrasInscritas'] as List<dynamic>?;

    return Estudante(
      id: doc.id,
      nome: data['nome'] ?? '',
      turma: data['turma'] ?? '',
      matricula: data['matricula'] ?? '',
      palestrasInscritas: palestrasInscritasData != null
        ? palestrasInscritasData.map((e) => e.toString()).toList()
        : [],
    );
  }
}
