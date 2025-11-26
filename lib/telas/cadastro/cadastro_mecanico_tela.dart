import 'package:flutter/material.dart';
import 'login_tela.dart';
import '../../services/auth_service.dart';
import '../../utils/validadores.dart';

class CadastroMecanicoScreen extends StatefulWidget {
  const CadastroMecanicoScreen({super.key});

  @override
  State<CadastroMecanicoScreen> createState() => _CadastroMecanicoScreenState();
}

class _CadastroMecanicoScreenState extends State<CadastroMecanicoScreen> {
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _horarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _concordaTermos = false;
  bool _isLoading = false;
  bool _obscureSenha = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    _enderecoController.dispose();
    _telefoneController.dispose();
    _horarioController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrarEmpresa() async {
    if (!_concordaTermos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você deve concordar com os termos e políticas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    // Verificar se email já existe
    final emailExiste = await AuthService.emailExiste(_emailController.text.trim());
    if (emailExiste) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este email já está em uso'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Primeiro registrar a empresa
      final sucessoEmpresa = await AuthService.registrarEmpresa(
        nome: _nomeController.text.trim(),
        cnpj: _cnpjController.text.trim(),
        endereco: _enderecoController.text.trim(),
        telefone: _telefoneController.text.trim(),
        horarioFuncionamento: _horarioController.text.trim(),
      );

      if (sucessoEmpresa) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Empresa cadastrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cadastrar empresa. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cadastro Empresarial',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Crie sua conta Empresarial",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                
                // Nome da Empresa
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: "Nome da Oficina ou Empresa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.business),
                  ),
                  validator: Validadores.validarNome,
                ),
                const SizedBox(height: 15),

                // CNPJ
                TextFormField(
                  controller: _cnpjController,
                  decoration: InputDecoration(
                    labelText: "CNPJ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  validator: Validadores.validarCNPJ,
                ),
                const SizedBox(height: 15),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validadores.validarEmail,
                ),
                const SizedBox(height: 15),

                // Senha
                TextFormField(
                  controller: _senhaController,
                  obscureText: _obscureSenha,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureSenha ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureSenha = !_obscureSenha;
                        });
                      },
                    ),
                  ),
                  validator: Validadores.validarSenha,
                ),
                const SizedBox(height: 15),

                // Endereço
                TextFormField(
                  controller: _enderecoController,
                  decoration: InputDecoration(
                    labelText: "Endereço completo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o endereço';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Telefone
                TextFormField(
                  controller: _telefoneController,
                  decoration: InputDecoration(
                    labelText: "Telefone para contato",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: Validadores.validarTelefone,
                ),
                const SizedBox(height: 15),

                // Horário de Funcionamento
                TextFormField(
                  controller: _horarioController,
                  decoration: InputDecoration(
                    labelText: "Horário de funcionamento",
                    hintText: "ex: Segunda a Sexta: 08:00-18:00",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o horário de funcionamento';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Checkbox termos - CORRIGIDO
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _concordaTermos,
                        activeColor: Colors.orange,
                        onChanged: (val) {
                          setState(() {
                            _concordaTermos = val ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "Eu concordo com os ",
                            style: TextStyle(color: Colors.black87),
                            children: [
                              TextSpan(
                                text: "termos & política",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              TextSpan(
                                text: " da empresa.",
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Botão Cadastrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _cadastrarEmpresa,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Cadastrar Empresa",
                            style: TextStyle(
                              fontSize: 16, 
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Link para login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Já possui uma conta? ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Faça login",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}