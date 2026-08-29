import 'package:flutter/material.dart';

class AgendamentoScreen extends StatefulWidget {
  const AgendamentoScreen({super.key});

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agendamentos', style: TextStyle(fontSize: 23)),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            // conteúdo vem nas próximas partes
          ],
        ),
      ),
    );
  }
}