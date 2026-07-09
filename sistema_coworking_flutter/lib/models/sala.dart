class Sala { 
   
  int? idSala; 
   
  String nomeSala; 
   
  //construtor
  Sala ({ 
    this.idSala, 
    required this.nomeSala,
  }); 
   
  Map<String, dynamic> toMap() { 
    return { 
      'id_sala': idSala, 
      'nome_sala': nomeSala,
    };
  } 
   
  factory Sala.fromMap(Map<String, dynamic> map) { 
    return Sala( 
      idSala: map['id_sala'], 
      nomeSala: map['nome_sala'],
    );
  }
}