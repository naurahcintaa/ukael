import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      print('Login berhasil! Nama: $_name, Email: $_email');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mencoba Login sebagai $_name ($_email)...'),
          backgroundColor: Color.fromARGB(255, 232, 221, 203),
        ),
      );
    
      Navigator.of(context).pushReplacementNamed(
        '/',
        arguments: {
          'userName': _name,
          'userEmail': _email,
        },
      ); 
    } else {
      print('Gagal. Harap isi semua field.');
    }
  }
  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.menu_book_rounded, 
          size: 100,
          color: Color.fromRGBO(74, 52, 44, 1),
        ),
        const SizedBox(height: 20),
        Text(
          'Library App',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(74, 52, 44, 1),
          ),
        ),
        const SizedBox(height: 8),

        Text(
          'Masuk untuk mengakses koleksi buku Anda.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(74, 52, 44, 1).withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
  //card login
  Widget _buildLoginCard(ColorScheme colorScheme) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              // nama
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Nama Lengkap Anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person_outline, color: Color.fromRGBO(74, 52, 44, 1)),
                ),
                keyboardType: TextInputType.name,
                onSaved: (value) => _name = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // email
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Alamat Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.email_outlined, color: Color.fromRGBO(74, 52, 44, 1)),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Masukkan alamat email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // password
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Kata Sandi Rahasia',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock_outline, color:Color.fromRGBO(74, 52, 44, 1)),
                ),
                obscureText: true, 
                onSaved: (value) => _password = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _handleLogin,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface, 
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(colorScheme),
                _buildLoginCard(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}