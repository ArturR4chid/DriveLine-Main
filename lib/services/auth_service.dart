import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/widget/user_widget.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.100.201:3000';
  static const String apiUsuarios = '$baseUrl/usuarios'; // ✅ SEM /api


  // ✅ LOGIN - Corrigido para usar /api/usuarios/login
  static Future<Usuario?> login(String email, String senha) async {
    try {
      print('🔐 Enviando login para: $apiUsuarios/login');
      print('📧 Email: $email');

      final response = await http.post(
        Uri.parse('$apiUsuarios/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📡 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        
        // Se a resposta incluir um objeto 'usuario'
        if (json['usuario'] != null) {
          return Usuario.fromJson(json['usuario']);
        }
        
        // Se a resposta for direto o usuário
        return Usuario.fromJson(json);
      } else if (response.statusCode == 401) {
        print('❌ Credenciais inválidas');
        return null;
      } else {
        print('❌ Erro ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Erro ao fazer login: $e');
      return null;
    }
  }

  // ✅ REGISTRAR USUÁRIO
  static Future<bool> registrarUsuario(Usuario usuario) async {
    try {
      print('📝 Registrando usuário: ${usuario.nome}');
      
      final response = await http.post(
        Uri.parse(apiUsuarios),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario.toJson()),
      ).timeout(const Duration(seconds: 10));

      print('📡 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 201) {
        print('✅ Usuário cadastrado com sucesso');
        return true;
      } else {
        print('❌ Erro ao registrar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erro ao registrar usuário: $e');
      return false;
    }
  }

  // ✅ VERIFICAR SE EMAIL JÁ EXISTE
  static Future<bool> emailExiste(String email) async {
    try {
      final response = await http.get(
        Uri.parse(apiUsuarios),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final usuarios = jsonDecode(response.body) as List;
        return usuarios.any((u) => u['email'] == email);
      }
      return false;
    } catch (e) {
      print('❌ Erro ao verificar email: $e');
      return false;
    }
  }

  // ✅ OBTER USUÁRIO POR ID
  static Future<Usuario?> getUsuario(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUsuarios/$id'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Usuario.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('❌ Erro ao obter usuário: $e');
      return null;
    }
  }

  // ✅ ATUALIZAR USUÁRIO
  static Future<bool> atualizarUsuario(int id, Usuario usuario) async {
    try {
      print('🔄 Atualizando usuário ID: $id');
      
      final response = await http.put(
        Uri.parse('$apiUsuarios/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario.toJson()),
      ).timeout(const Duration(seconds: 10));

      print('📡 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Usuário atualizado com sucesso');
        return true;
      } else {
        print('❌ Erro ao atualizar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erro ao atualizar usuário: $e');
      return false;
    }
  }

  // ✅ DELETAR USUÁRIO
  static Future<bool> deletarUsuario(int id) async {
    try {
      print('🗑️ Deletando usuário ID: $id');
      
      final response = await http.delete(
        Uri.parse('$apiUsuarios/$id'),
      ).timeout(const Duration(seconds: 10));

      print('📡 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Usuário deletado com sucesso');
        return true;
      } else {
        print('❌ Erro ao deletar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erro ao deletar usuário: $e');
      return false;
    }
  }

  // ✅ ATUALIZAR SENHA
  static Future<bool> atualizarSenha(int id, String novaSenha) async {
    try {
      print('🔑 Atualizando senha do usuário ID: $id');
      
      final response = await http.put(
        Uri.parse('$apiUsuarios/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'senha': novaSenha}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Senha atualizada com sucesso');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Erro ao atualizar senha: $e');
      return false;
    }
  }

  static Future<dynamic> registrarEmpresa({
    required String nome,
    required String cnpj,
    required String endereco,
    required String telefone,
    required String horarioFuncionamento,
  }) async {
    try {
      print('📝 Registrando empresa: $nome');

      const String baseUrlEmpresas = 'http://192.168.100.201:3000/empresas';

      final response = await http.post(
        Uri.parse(baseUrlEmpresas),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'razao_social': nome,
          'cnpj': cnpj,
          'endereco': endereco,
          'telefone': telefone,
          'horarioFuncionamento': horarioFuncionamento,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📡 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Empresa cadastrada com sucesso');
        return true;
      } else {
        print('❌ Erro ao registrar empresa: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erro ao registrar empresa: $e');
      return false;
    }
  }
}

