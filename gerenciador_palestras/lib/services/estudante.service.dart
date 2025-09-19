import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciador_palestras/models/estudante.dart';

class CustomerService {
  final CollectionReference students = FirebaseFirestore.instance.collection("estudantes");

  Future<Future<DocumentReference<Object?>>> addStudent(Estudante student) async {
    return students.add({
      "nome": student.nome,
      "matricula": student.matricula,
      "turma": student.turma,
    });
  }

  Future<void> updateCustomer(String id, Estudante student) {
    return students.doc(id).update({
      "nome": student.nome,
      "matricula": student.matricula,
      "turma": student.turma,
    });
  }
}