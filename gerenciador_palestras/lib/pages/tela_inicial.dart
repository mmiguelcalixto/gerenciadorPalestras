import 'package:flutter/material.dart';
import 'package:gerenciador_palestras/pages/palestras.dart';
import 'package:gerenciador_palestras/pages/student_profile_page.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Selecione uma opção",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color:  Color.fromARGB(255, 163, 130, 248),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentProfilePage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15.0,
                          spreadRadius: 1.0,
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.school,
                          size: 100,
                          color:  Color.fromARGB(255, 163, 130, 248),
                        ),
                        Text("Estudantes",
                          style: TextStyle(
                            color:  Color.fromARGB(255, 88, 88, 88),
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Palestras(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15.0,
                          spreadRadius: 1.0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.record_voice_over,
                          size: 100,
                          color:  Color.fromARGB(255, 163, 130, 248),
                        ),
                        SizedBox(height: 8),
                      Text("Palestras",
                        style: TextStyle(
                          color:  Color.fromARGB(255, 88, 88, 88),
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}