class Agendamento{ 

  int? idAgendamento; 
   
  String dataHoraInicio; 
   
  String dataHoraFim; 
   
  int idSala; 
   
  String? nomeSala; 
   
  Agendamento({ 
    this.idAgendamento, 
    required this.dataHoraInicio, 
    required this.dataHoraFim, 
    required this.idSala, 
    this.nomeSala, 
  }); 
   
  Map<String, dynamic> toMap() { 
    return{ 
      'id_agendamento': idAgendamento, 
      'data_hora_inicio': dataHoraInicio, 
      'data_hora_fim': dataHoraFim, 
      'id_sala': idSala,
    };
  } 
   
  factory Agendamento.fromMap(Map<String, dynamic> map) { 
    return Agendamento( 
      idAgendamento: map['id_agendamento'], 
      dataHoraInicio: map['data_hora_inicio'], 
      dataHoraFim: map['data_hora_fim'], 
      idSala: map['id_sala'], 
      nomeSala: map['nome_sala']
    );
  }
}