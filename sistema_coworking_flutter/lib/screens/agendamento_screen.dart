import 'package:flutter/material.dart'; 
import '../models/sala.dart';
import '../repositories/sala_repository.dart';

class AgendamentoScreen extends StatefulWidget {
  const AgendamentoScreen({super.key});

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
   
  final SalaRepository _salaRepository = SalaRepository();

  List<Sala> _salas = [];

  Sala? _salaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarSalas();
  }

  Future<void> _carregarSalas() async {
    final salas = await _salaRepository.listarSalas();
    setState(() {
      _salas = salas;
    });
  } 

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