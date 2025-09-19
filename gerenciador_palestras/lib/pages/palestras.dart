import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_palestras/models/palestra.dart';
import 'package:gerenciador_palestras/pages/tela_inicial.dart';
import 'package:gerenciador_palestras/services/firestore.service.dart';
import 'package:gerenciador_palestras/services/palestra.service.dart';

class Palestras extends StatefulWidget {
  const Palestras({super.key});

  @override
  State<Palestras> createState() => _PalestrasState();
}

class _PalestrasState extends State<Palestras> {

  final FirestoreService firestoreService = FirestoreService();
  final PalestraService palestraService = PalestraService();
  final CollectionReference palestras = FirebaseFirestore.instance.collection("palestras");

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _palestranteController = TextEditingController();
  final TextEditingController _vagastotalController = TextEditingController();

  void clearTexts() {
    _tituloController.clear();
    _palestranteController.clear();
    _vagastotalController.clear();
  }

  Future<void> showInsertModal({String? id}) async {
    if (id != null) {
      DocumentSnapshot palestrante = await firestoreService.getById(id, palestras);
      
      Map<String, dynamic> palestranteData = palestrante.data() as Map<String, dynamic>;

      _tituloController.text = palestranteData["titulo"];
      _palestranteController.text = palestranteData["palestrante"];
      _vagastotalController.text = palestranteData["vagasTotal"].toString();
    }

    showDialog(context: context, builder: (context) => AlertDialog(      
      content: 
        Column(
          children: [
          Text("Título da palestra:"),
          TextField(controller: _tituloController),

          Text("Palestrante:"),
          TextField(controller: _palestranteController),

          Text("Total de vagas: "),
          TextField(controller: _vagastotalController),
          ]
        ),
      actions: [
        ElevatedButton(onPressed: () {
          final palestra = Palestra
          (
            titulo: _tituloController.text,
            palestrante: _palestranteController.text,
            vagasTotal: int.parse(_vagastotalController.text),
            vagasDisponiveis: int.parse(_vagastotalController.text),
          );

          if (id == null ) {
            palestraService.addPalestra(palestra);
          } else {
            palestraService.updatePalestra(id, palestra);
          }

          clearTexts();
          Navigator.pop(context);
          
        }, child: Text(id == null ? "Adicionar" : "Editar"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaInicial()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.home,
                      size: 30,
                      color: Color.fromARGB(255, 163, 130, 248),
                    ),
                    Text(
                      "Tela Inicial",
                      style: TextStyle(
                        color: Color.fromARGB(255, 163, 130, 248),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.get(palestraService.palestras),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List palestraList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: palestraList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot palestra = palestraList[index];
                String palestraId = palestra.id;
                Map<String, dynamic> data = palestra.data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Color.fromARGB(255, 163, 130, 248),
                          child: const Icon(
                            Icons.record_voice_over,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["titulo"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                children: [
                                  Text("Palestrante: ", 
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    data["palestrante"],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  Text("Vagas disponíveis: ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    data["vagasDisponiveis"].toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => showInsertModal(id: palestraId),
                              icon: const Icon(Icons.edit, color: Colors.orange),
                            ),
                            IconButton(
                              onPressed: () => firestoreService.delete(
                                palestraId,
                                palestraService.palestras,
                              ),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Text("Não há palestras no banco de dados.");
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showInsertModal,

        child: const Icon(Icons.add)
      ),
    );
  }
}