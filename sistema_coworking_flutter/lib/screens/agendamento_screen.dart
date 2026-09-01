import 'package:flutter/material.dart'; 
import '../models/sala.dart';
import '../repositories/sala_repository.dart'; 
import '../models/agendamento.dart';
import '../repositories/agendamento_repository.dart';

class AgendamentoScreen extends StatefulWidget {
  const AgendamentoScreen({super.key});

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
   
  final SalaRepository _salaRepository = SalaRepository(); 

  List<Sala> _salas = []; 
   
  final AgendamentoRepository _agendamentoRepository = AgendamentoRepository();

  List<Agendamento> _agendamentos = [];

  Sala? _salaSelecionada; 
   
  DateTime? _dataInicio; 
   
  DateTime? _dataFim;

  @override
  void initState() {
    super.initState();
    _carregarSalas(); 
    _carregarAgendamentos();
  }

  Future<void> _carregarSalas() async {
    final salas = await _salaRepository.listarSalas();
    setState(() {
      _salas = salas;
    });
  } 

  Future<void> _carregarAgendamentos() async {
    final agendamentos = await _agendamentoRepository.listarAgendamento();
    setState(() {
      _agendamentos = agendamentos;
    });
  } 

  String _formatarDataExibicao(DateTime data) {
    String dois(int numero) => numero.toString().padLeft(2, '0');
    return '${dois(data.day)}/${dois(data.month)}/${data.year} ${dois(data.hour)}:${dois(data.minute)}';
  } 

  String _formatarDataBanco(DateTime data) {
    String dois(int numero) => numero.toString().padLeft(2, '0');
    return '${data.year}-${dois(data.month)}-${dois(data.day)} ${dois(data.hour)}:${dois(data.minute)}:00';
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
             
            SizedBox(height: 40),

            ElevatedButton( 

              onPressed: () async {

                final data = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2030),
                ); 

                if (data == null) return;
                if (!context.mounted) return;

                final hora = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (hora == null) return;

                setState(() {
                  _dataInicio = DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
                });
              },
              child: Text(_dataInicio == null ? 'Selecionar início' : 'Início: ${_formatarDataExibicao(_dataInicio!)}'),
            ), 
             
            SizedBox(height: 10), 
             
            ElevatedButton( 

              onPressed: () async {

                final data = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2030),
                );
                if (data == null) return;

                if (!context.mounted) return;

                final hora = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (hora == null) return;

                setState(() {
                  _dataFim = DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
                });
              },
              child: Text(_dataFim == null ? 'Selecionar fim' : 'Fim: ${_formatarDataExibicao(_dataFim!)}'),
            ), 
             
            SizedBox(height: 20), 
             
            ElevatedButton(
              onPressed: () async {

                if (_salaSelecionada == null || _dataInicio == null || _dataFim == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selecione a sala e as datas.')),
                  );
                  return;
                }

                try {

                  Agendamento novoAgendamento = Agendamento(
                    idSala: _salaSelecionada!.idSala!,
                    dataHoraInicio: _formatarDataBanco(_dataInicio!),
                    dataHoraFim: _formatarDataBanco(_dataFim!),
                  );

                  await _agendamentoRepository.inserirAgendamento(novoAgendamento);
                  await _carregarAgendamentos();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Agendamento criado com sucesso!')),
                  );

                } catch (erro) {

                  if (!context.mounted) return;

                  if (erro.toString().contains('CHECK')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('A data de fim deve ser maior que a de início.')),
                    );
                  } else if (erro.toString().contains('ocupada')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Essa sala já está ocupada nesse horário.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao criar agendamento.')),
                    );
                  }
                }
              },
              child: Text('Criar Agendamento'),
            ), 
             
            SizedBox(height: 30), 
             
            Expanded(
              child: ListView.builder(
                itemCount: _agendamentos.length,
                itemBuilder: (context, index) {
                  final agendamento = _agendamentos[index];

                  return ListTile(
                    title: Text(agendamento.nomeSala ?? ''),
                    subtitle: Text('${agendamento.dataHoraInicio} até ${agendamento.dataHoraFim}'), 
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirmação'),
                              content: Text('Tem certeza que deseja excluir este agendamento?'),
                              actions: [ 

                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    try {
                                      await _agendamentoRepository.excluirAgendamento(agendamento.idAgendamento!);
                                      await _carregarAgendamentos();

                                      if (!context.mounted) return;

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Agendamento excluído com sucesso!')),
                                      );
                                    } catch (erro) {
                                      if (!context.mounted) return;

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Erro ao excluir agendamento.')),
                                      );
                                    }
                                  },
                                  child: Text('Sim'),
                                ), 
                                 
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Não'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ); 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}