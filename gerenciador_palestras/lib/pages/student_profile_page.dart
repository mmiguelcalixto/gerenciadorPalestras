import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/estudante.dart';
import 'student_lectures_page.dart';

class StudentProfilePage extends StatefulWidget {
  final Estudante estudante;
  const StudentProfilePage({required this.estudante, super.key});

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _turmaController;
  late final TextEditingController _matriculaController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.estudante.nome);
    _turmaController = TextEditingController(text: widget.estudante.turma);
    _matriculaController = TextEditingController(text: widget.estudante.matricula);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _turmaController.dispose();
    _matriculaController.dispose();
    super.dispose();
  }

  Future<void> _saveStudentData() async {
    if (_formKey.currentState!.validate()) {
      widget.estudante.nome = _nomeController.text;
      widget.estudante.turma = _turmaController.text;
      widget.estudante.matricula = _matriculaController.text;

      await FirebaseFirestore.instance
          .collection('estudantes')
          .doc(widget.estudante.id)
          .set({
        'nome': widget.estudante.nome,
        'turma': widget.estudante.turma,
        'matricula': widget.estudante.matricula,
        'palestrasInscritas': widget.estudante.palestrasInscritas,
      }, SetOptions(merge: true));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentLecturesPage(estudante: widget.estudante),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Estudante'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _turmaController,
                decoration: const InputDecoration(labelText: 'Turma'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua turma.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _matriculaController,
                decoration: const InputDecoration(labelText: 'Matrícula'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua matrícula.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveStudentData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Salvar e Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
