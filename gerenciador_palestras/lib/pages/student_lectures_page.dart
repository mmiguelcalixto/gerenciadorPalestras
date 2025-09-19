import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/estudante.dart';
import '../models/palestra.dart';
import '../services/lecture_service.dart';

class StudentLecturesPage extends StatefulWidget {
  final Estudante estudante;
  const StudentLecturesPage({required this.estudante, super.key});

  @override
  State<StudentLecturesPage> createState() => _StudentLecturesPageState();
}

class _StudentLecturesPageState extends State<StudentLecturesPage> {
  final PalestraService _palestraService = PalestraService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha suas Palestras'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/img/unnamed.png',
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('palestras').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Ocorreu um erro: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final palestras = snapshot.data!.docs
                    .map((doc) => Palestra.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  itemCount: palestras.length,
                  itemBuilder: (context, index) {
                    final palestra = palestras[index];
                    final isRegistered = widget.estudante.palestrasInscritas.contains(palestra.id);
                    final canRegister =
                        widget.estudante.palestrasInscritas.length < 2 &&
                            palestra.vagasDisponiveis > 0 &&
                            !isRegistered;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          palestra.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Palestrante: ${palestra.palestrante}'),
                            Text(
                              'Vagas disponíveis: ${palestra.vagasDisponiveis}/${palestra.vagasTotal}',
                              style: TextStyle(
                                color: palestra.vagasDisponiveis > 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: canRegister || isRegistered ? () async {
                            try {
                              if (isRegistered) {
                                await _palestraService.unregister(widget.estudante.id, palestra);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Inscrição cancelada com sucesso!')),
                                );
                              } else if (canRegister) {
                                await _palestraService.register(widget.estudante.id, palestra);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Inscrição realizada com sucesso!')),
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro: ${e.toString()}')),
                              );
                            }
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRegistered ? Colors.red : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isRegistered ? 'Cancelar' : 'Inscrever',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
