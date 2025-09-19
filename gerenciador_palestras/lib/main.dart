import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; 
import 'pages/student_lectures_page.dart';
import 'models/estudante.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscrição em Palestras - Dia D carreiras',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('estudantes').doc('a').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados do estudante: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Estudante não encontrado'));
          }

          final estudante = Estudante.fromFirestore(snapshot.data!);

          return StudentLecturesPage(estudante: estudante);
        },
      ),
    );
  }
}
