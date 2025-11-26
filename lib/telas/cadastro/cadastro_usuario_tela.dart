import 'package:flutter/material.dart';
import 'cadastro_info_veiculo.dart';
import '../../services/auth_service.dart';
import '../../utils/validadores.dart';
import '../../models/widget/user_widget.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _authService = AuthService();
  bool _concordaTermos = false;
  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<void> _proximaEtapa() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_concordaTermos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você deve concordar com os termos e políticas'),
          backgroundColor: Colors.red,
        ),
      );
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
      // Criar novo usuário
      final novoUsuario = Usuario(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text.trim(),
        telefone: _telefoneController.text.trim(),
        cpf: _cpfController.text.trim(),
        tipo: 'usuario',
      );

      // Registrar usuário na API
      final sucesso = await AuthService.registrarUsuario(novoUsuario);
      
      if (sucesso) {
        print('✅ Usuário criado com sucesso!');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CadastroVeiculoScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao criar conta. Tente novamente.'),
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
      setState(() {
        _isLoading = false;
      });
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
          'Cadastro',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Crie sua conta",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: "Nome",
                  hintText: "ex: Arthur Santos",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: Validadores.validarNome,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "ex: arthur.ios@email.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validadores.validarEmail,
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),

              // Confirmar Senha
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: _obscureConfirmarSenha,
                decoration: InputDecoration(
                  labelText: "Confirmar senha",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmarSenha ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmarSenha = !_obscureConfirmarSenha;
                      });
                    },
                  ),
                ),
                validator: (value) => Validadores.validarConfirmarSenha(
                  _senhaController.text, 
                  value
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),

              // Telefone
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: "Telefone",
                  hintText: "ex: 38 9999-9999",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: Validadores.validarTelefone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),

              // CPF
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(
                  labelText: "CPF",
                  hintText: "ex: 000.000.000-00",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                validator: Validadores.validarCPF,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 15),

              // Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _concordaTermos,
                    onChanged: (value) {
                      setState(() {
                        _concordaTermos = value ?? false;
                      });
                    },
                    activeColor: Colors.orange,
                  ),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "Eu concordo com os ",
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: "terms & policy.",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Botão próxima etapa
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _proximaEtapa,
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
                          "Próxima etapa",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "ou faça Cadastro rápido com",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.g_mobiledata),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.facebook),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.alternate_email),
                ],
              ),
              const SizedBox(height: 20),

              // Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Já possui uma conta? ",
                    style: TextStyle(color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Logue",
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
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Icon(
        icon,
        color: Colors.orange,
        size: 24,
      ),
    );
  }
}