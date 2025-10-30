import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MissionsPage extends StatefulWidget {
  static const String name = 'missions_page';
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

enum MissionStatus { available, inProgress }

class Mission {
  final String title;
  final String short;
  final int reward;
  MissionStatus status;

  Mission({
    required this.title,
    required this.short,
    required this.reward,
    this.status = MissionStatus.available,
  });
}

class _MissionsPageState extends State<MissionsPage> {
  final missions = <Mission>[
    Mission(
      title: 'Recicla objetos sólidos',
      short: 'plásticos, latas, papel, bolsa, cartón, vidrios, cable',
      reward: 80,
    ),
  ];

  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFBFEAFC),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Misiones', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(width: 6),
            Icon(Icons.help_outline_rounded, size: 18),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Racha
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _card(),
                child: Row(
                  children: [
                    const Text('¡Sigue tu racha!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Icon(Icons.local_fire_department_rounded,
                        color: Colors.orange.shade700, size: 28),
                    const SizedBox(width: 6),
                    const Text('10',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Recompensa especial (decorativa)
              _SpecialRewardCard(
                title: '¡Realiza tu Eco Quiz!',
                subtitle:
                    'Aprende sobre el reciclaje y gana puntos mientras lo haces.',
                reward: 100,
                onAccept: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Eco Quiz aceptado')),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Chips (decorativos)
              Wrap(
                spacing: 8,
                children: const [
                  _CategoryChip(label: 'Reciclaje', icon: Icons.eco_rounded),
                  _CategoryChip(label: 'Empresas', icon: Icons.bolt_rounded, selected: true),
                  _CategoryChip(label: 'Prendas', icon: Icons.checkroom_rounded),
                ],
              ),
              const SizedBox(height: 12),

              // Misiones
              for (int i = 0; i < missions.length; i++)
                _MissionCard(
                  mission: missions[i],
                  onTapPrimary: () => _onPrimaryPressed(i),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Lógica del botón primario de la tarjeta
  Future<void> _onPrimaryPressed(int index) async {
    final m = missions[index];

    // Si está disponible: sheet -> confirm -> pasar a "Seguir"
    if (m.status == MissionStatus.available) {
      final accepted = await _openAcceptFlow(context, m);
      if (accepted == true) {
        setState(() => missions[index].status = MissionStatus.inProgress);
      }
      return;
    }

    // Si ya está en progreso: abrir popup con "Subir" / "Cancelar"
    final action = await showDialog<_FollowAction>(
      context: context,
      barrierDismissible: true,
      builder: (context) => _FollowPopup(missionTitle: m.title),
    );

    if (action == _FollowAction.cancel) return;

    if (action == _FollowAction.upload) {
      // 1) abrir cámara
      final XFile? shot = await _picker.pickImage(source: ImageSource.camera);
      if (shot == null) return;

      // 2) navegar a página de progreso (Figura 3) y luego mostrar imagen (Figura 4)
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MissionProgressPage(
            mission: m,
            imageFile: File(shot.path),
          ),
        ),
      );
    }
  }

  // --- Flow de aceptación (ya implementado antes) ---
  Future<bool?> _openAcceptFlow(BuildContext context, Mission m) async {
    final fromSheet = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MissionDetailSheet(
          title: m.title,
          short: m.short,
          onAccept: () => Navigator.of(context).pop(true),
        );
      },
    );

    if (fromSheet == true) {
      final cont = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => _ConfirmDialog(missionTitle: m.title),
      );
      return cont == true;
    }
    return false;
  }
}

/// ------------------ Pantalla de PROGRESO (Fig. 3 y 4) ------------------
class MissionProgressPage extends StatefulWidget {
  final Mission mission;
  final File imageFile;
  const MissionProgressPage({super.key, required this.mission, required this.imageFile});

  @override
  State<MissionProgressPage> createState() => _MissionProgressPageState();
}

class _MissionProgressPageState extends State<MissionProgressPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _simulateBackend();
  }

  Future<void> _simulateBackend() async {
    // TODO (BACKEND): reemplazar por tu llamada HTTP a la API de análisis.
    // Por ejemplo:
    // final resp = await http.post(Uri.parse(API_URL), body: {...});
    // setState(() { _loading = false; resultados = resp.body; });
    await Future.delayed(const Duration(seconds: 2)); // Simulación de análisis
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFBFEAFC),
        centerTitle: true,
        title: const Text('Misión'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.mission.title,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFD2F3D0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.backpack_rounded, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.mission.short,
                  style: TextStyle(color: Colors.black.withOpacity(.7)),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.monetization_on_outlined, size: 20),
              const SizedBox(width: 4),
              Text('${widget.mission.reward}',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Tu misión está siendo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),

          // Área “loading” o imagen cargada
          Center(
            child: Container(
              width: double.infinity,
              height: 240,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              child: _loading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                        SizedBox(height: 8),
                        Text('Espere...'),
                      ],
                    )
                  : FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: Image.file(widget.imageFile),
                    ),
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 8),
          Text('Prueba a hacer estas misiones...',
              style: TextStyle(color: Colors.black.withOpacity(.7))),
          const SizedBox(height: 12),
          // Sugerencia (estática)
          Container(
            decoration: _card(),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD2F3D0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.backpack_rounded),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Reciclaje en la familia',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                ),
                _PrimaryButton(
                  label: 'Aceptar',
                  color: const Color(0xFF31B14F),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- POPUP "Seguir" (Figura 1) ----------------
enum _FollowAction { upload, cancel }

class _FollowPopup extends StatelessWidget {
  final String missionTitle;
  const _FollowPopup({required this.missionTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: const [
                Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                Spacer(),
                Icon(Icons.help_outline_rounded),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              missionTitle,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            // Contenido (idéntico a la hoja)
            Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD2F3D0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.backpack_rounded, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'plásticos, latas, papel, bolsa, cartón, vidrios, cable',
                    style: TextStyle(color: Colors.black.withOpacity(.7)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _Bullet(text: 'Recolecta uno de los materiales descritos.'),
            const _Bullet(text: 'Junta hasta 3 latas o botellas plásticas.'),
            const _Bullet(text: 'Toma una foto del material reciclado.'),
            const _Bullet(text: 'Espere hasta que se confirme la misión.'),
            const _Bullet(text: 'Canjee sus puntos ganados por la misión.'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _PrimaryButton(
                    label: 'Subir  📷',
                    color: const Color(0xFF12A1BC),
                    onPressed: () => Navigator.of(context).pop(_FollowAction.upload),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PrimaryButton(
                    label: 'Cancelar',
                    color: const Color(0xFFE25741),
                    onPressed: () => Navigator.of(context).pop(_FollowAction.cancel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- Widgets reutilizables (cards, botones, etc.) ----------------
class _MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onTapPrimary;
  const _MissionCard({required this.mission, required this.onTapPrimary});

  @override
  Widget build(BuildContext context) {
    final isFollowing = mission.status == MissionStatus.inProgress;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: _card(),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFD2F3D0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.backpack_rounded, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(mission.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 2),
                    Text(
                      mission.short,
                      style: TextStyle(color: Colors.black.withOpacity(.70)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('${mission.reward} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16)),
                        const Icon(Icons.monetization_on_outlined, size: 20),
                        const Spacer(),
                        _PrimaryButton(
                          label: isFollowing ? 'Seguir' : 'Aceptar',
                          color: isFollowing
                              ? const Color(0xFF12A1BC)
                              : const Color(0xFF31B14F),
                          onPressed: onTapPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isFollowing)
            const Positioned(
              right: 0,
              top: 0,
              child: Icon(Icons.info_outline, color: Colors.black45),
            ),
        ],
      ),
    );
  }
}

class _SpecialRewardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int reward;
  final VoidCallback onAccept;

  const _SpecialRewardCard({
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _card(borderColor: const Color(0xFFF4A41C)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF4A41C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Text(
              'RECOMPENSA ESPECIAL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: .4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt_rounded, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style:
                              TextStyle(color: Colors.black.withOpacity(.7))),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('$reward ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16)),
                          const Icon(Icons.monetization_on_outlined, size: 20),
                          const Spacer(),
                          _PrimaryButton(
                            label: 'Aceptar',
                            color: const Color(0xFF31B14F),
                            onPressed: onAccept,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  const _CategoryChip({required this.label, required this.icon, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFF4A41C) : Colors.black12;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFF6E6) : Colors.white,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: selected ? const Color(0xFFF4A41C) : null),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFFF4A41C) : Colors.black87,
              )),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _MissionDetailSheet extends StatelessWidget {
  final String title;
  final String short;
  final VoidCallback onAccept;

  const _MissionDetailSheet({
    required this.title,
    required this.short,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context, false),
            child: Container(color: Colors.black.withOpacity(.5)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      Spacer(),
                      Icon(Icons.help_outline_rounded),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD2F3D0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.backpack_rounded, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(short,
                            style: TextStyle(
                              color: Colors.black.withOpacity(.72),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _Bullet(text: 'Recolecta uno de los materiales descritos.'),
                  const _Bullet(text: 'Junta hasta 3 latas o botellas plásticas.'),
                  const _Bullet(text: 'Toma una foto del material reciclado.'),
                  const _Bullet(text: 'Espere hasta que se confirme la misión.'),
                  const _Bullet(text: 'Canjee sus puntos ganados por la misión.'),
                  const SizedBox(height: 16),
                  Center(
                    child: _PrimaryButton(
                      label: 'Aceptar',
                      color: const Color(0xFF12A1BC),
                      onPressed: onAccept,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String missionTitle;
  const _ConfirmDialog({required this.missionTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¡Genial!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Text(
              'Tu misión $missionTitle está dentro de tus misiones pendientes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withOpacity(.8)),
            ),
            const SizedBox(height: 18),
            _PrimaryButton(
              label: 'Continuar',
              color: const Color(0xFF4BAF2E),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

BoxDecoration _card({Color? borderColor}) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor ?? Colors.transparent, width: 1.2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
