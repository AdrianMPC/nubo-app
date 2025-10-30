import 'package:flutter/material.dart';

class RecuperarContrasenaPage extends StatefulWidget {
  const RecuperarContrasenaPage({super.key});

  @override
  State<RecuperarContrasenaPage> createState() => _RecuperarContrasenaPageState();
}

class _RecuperarContrasenaPageState extends State<RecuperarContrasenaPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingrese su correo';
    final emailRx = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRx.hasMatch(value)) return 'Correo no válido';
    return null;
  }

  Future<void> _onContinuar() async {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Si el correo existe, enviaremos un mensaje.')),
    );
  }

  void _onEnviarDeNuevo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reenviando correo…')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // como en la imagen
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // título
                  Text(
                    'Recuperar contraseña',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // descripción
                  Text(
                    'Escriba el correo de su cuenta,\nsi existe se le enviará un correo.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 26),

                  // formulario
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // caja de correo
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3E6EB), // gris como el de la imagen
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: _emailValidator,
                            decoration: const InputDecoration(
                              hintText: 'Correo',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // enviar de nuevo
                        TextButton(
                          onPressed: _onEnviarDeNuevo,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Enviar de nuevo',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.black87,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // botón continuar
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _onContinuar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3C82C3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Continuar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  Text(
                    'Nubo ©Copyright 2025',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
