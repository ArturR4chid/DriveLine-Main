import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ✅ USE SEU IP CORRETO
  static const String baseUrl = 'http://192.168.100.201:3000';
  
  // ❌ COMENTADO: localhost não funciona no Flutter
  // static const String baseUrl = 'http://localhost:3000';
  
  // ❌ COMENTADO: 10.0.2.2 só funciona no Android Emulator
  // static const String baseUrl = 'http://10.0.2.2:3000';

  static final http.Client client = http.Client();

  // Método genérico para requisições
  static Future<dynamic> request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      print('🌐 API: $method $url');

      final response = await http.Request(method, url)
        ..headers['Content-Type'] = 'application/json'
        ..body = body != null ? jsonEncode(body) : '';

      final streamedResponse = await response.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      print('📡 Resposta: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode >= 200 && streamedResponse.statusCode < 300) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Erro ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print('❌ Erro API: $e');
      throw Exception('Não foi possível conectar com a API');
    }
  }

  // ========== TESTE DE CONEXÃO ==========
  static Future<dynamic> testConnection() async {
    return await request(endpoint: '/', method: 'GET');
  }

  // ========== USUÁRIOS ==========
  static Future<List<dynamic>> getUsuarios() async {
    return await request(endpoint: '/usuarios', method: 'GET');
  }

  static Future<dynamic> createUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    return await request(
      endpoint: '/usuarios',
      method: 'POST',
      body: {
        'nome': nome,
        'email': email,
        'senha': senha,
      },
    );
  }

  static Future<dynamic> login(String email, String senha) async {
    return await request(
      endpoint: '/usuarios/login',
      method: 'POST',
      body: {'email': email, 'senha': senha},
    );
  }

  // ========== EMPRESAS ==========
  static Future<List<dynamic>> getEmpresas() async {
    return await request(endpoint: '/empresas', method: 'GET');
  }

  static Future<dynamic> createEmpresa({
    required String nome,
    required String cnpj,
    required String endereco,
  }) async {
    return await request(
      endpoint: '/empresas',
      method: 'POST',
      body: {
        'nome': nome,
        'cnpj': cnpj,
        'endereco': endereco,
      },
    );
  }

  // ========== VEÍCULOS ==========
  static Future<List<dynamic>> getVeiculos() async {
    return await request(endpoint: '/veiculos', method: 'GET');
  }

  static Future<dynamic> createVeiculo({
    required String modelo,
    required String placa,
    required int empresaId,
  }) async {
    return await request(
      endpoint: '/veiculos',
      method: 'POST',
      body: {
        'modelo': modelo,
        'placa': placa,
        'empresa_id': empresaId,
      },
    );
  }
}