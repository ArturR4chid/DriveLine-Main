class Usuario {
  final int? id;
  final String nome;
  final String cpf;
  final String email;
  final String senha;
  final String? telefone;
  final String? tipo;
  final int? empresa_id;

  Usuario({
    this.id,
    required this.cpf,
    required this.nome,
    required this.email,
    required this.senha,
    this.telefone,
    this.tipo = 'usuario',
    this.empresa_id,
  });

  // ✅ Converter JSON da API para Objeto Flutter
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int?,
      cpf: json['cpf'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      senha: json['senha'] as String? ?? '',
      telefone: json['telefone'] as String?,
      tipo: json['tipo'] as String? ?? 'usuario',
      empresa_id: json['empresa_id'] as int?,
    );
  }

  // ✅ Converter Objeto Flutter para JSON para enviar à API
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'tipo': tipo ?? 'usuario',
      'empresa_id': empresa_id,
    };
  }

  // ✅ Para debug/logs
  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, telefone: $telefone, tipo: $tipo)';
  }

  // ✅ Copiar usuário com mudanças
  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? senha,
    String? telefone,
    String? tipo,
    int? empresa_id,
  }) {
    return Usuario(
      id: id ?? this.id,
      cpf: cpf,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      telefone: telefone ?? this.telefone,
      tipo: tipo ?? this.tipo,
      empresa_id: empresa_id ?? this.empresa_id,
    );
  }
}
