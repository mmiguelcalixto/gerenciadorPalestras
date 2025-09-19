import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenciador_palestras/models/estudante.dart';
import 'student_lectures_page.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  StudentProfilePageState createState() => StudentProfilePageState();
}

class StudentProfilePageState extends State<StudentProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _turmaController;
  late final TextEditingController _matriculaController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _turmaController = TextEditingController();
    _matriculaController = TextEditingController();
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
      final doc = await FirebaseFirestore.instance
          .collection('estudantes')
          .add({
        'nome': _nomeController.text,
        'turma': _turmaController.text,
        'matricula': _matriculaController.text,
      });

      final estudante = Estudante(
        id: doc.id,
        nome: _nomeController.text,
        turma: _turmaController.text,
        matricula: _matriculaController.text,
        palestrasInscritas: [],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentLecturesPage(estudante: estudante),
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
                  backgroundColor: Color.fromARGB(255, 163, 130, 248),
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
