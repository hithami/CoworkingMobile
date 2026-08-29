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
        padding: EdgeInsets.all(40),
        child: Column(
          children: [ 
             
            Text(
              'Salas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),

            SizedBox(height: 20), 
             
            
            DropdownButton<Sala>(
              hint: Text(
                'Selecione a sala',
                style: TextStyle(fontSize: 20),
              ),
              value: _salaSelecionada,
              isExpanded: true,
              items: _salas.map((sala) {
                return DropdownMenuItem(
                  value: sala,
                  child: Text(sala.nomeSala),
                );
              }).toList(),
              onChanged: (sala) {
                setState(() {
                  _salaSelecionada = sala;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}