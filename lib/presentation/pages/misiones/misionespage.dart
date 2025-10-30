import 'package:flutter/material.dart';

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
  final List<Mission> missions = [
    Mission(
      title: 'Recicla objetos sólidos',
      short: 'plásticos, latas, papel, bolsa, cartón, vidrios, cable',
      reward: 80,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const acceptColor = Color(0xFF31B14F);

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
              // --- Racha ---
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

              // --- Recompensa especial ---
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

              // --- Chips (decorativos por ahora) ---
              Wrap(
                spacing: 8,
                children: const [
                  _CategoryChip(label: 'Reciclaje', icon: Icons.eco_rounded),
                  _CategoryChip(label: 'Empresas', icon: Icons.bolt_rounded, selected: true),
                  _CategoryChip(label: 'Prendas', icon: Icons.checkroom_rounded),
                ],
              ),
              const SizedBox(height: 12),

              // --- Tarjetas de misiones ---
              for (int i = 0; i < missions.length; i++)
                _MissionCard(
                  mission: missions[i],
                  onAccept: () => _openMissionDetail(i),
                  acceptColor: acceptColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --------- FLOW: Sheet -> Confirm -> Update ----------
  Future<void> _openMissionDetail(int index) async {
    final mission = missions[index];
    if (mission.status == MissionStatus.inProgress) {
      // Aquí podrías navegar al progreso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Siguiendo: ${mission.title}')),
      );
      return;
    }

    final acceptedFromSheet = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MissionDetailSheet(
          title: mission.title,
          short: mission.short,
          onAccept: () => Navigator.of(context).pop(true),
        );
      },
    );

    if (acceptedFromSheet == true) {
      final cont = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return _ConfirmDialog(missionTitle: mission.title);
        },
      );

      if (cont == true) {
        setState(() => missions[index].status = MissionStatus.inProgress);
      }
    }
  }
}

/// ------------------ Widgets ------------------

class _MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onAccept;
  final Color acceptColor;

  const _MissionCard({
    required this.mission,
    required this.onAccept,
    required this.acceptColor,
  });

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
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
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
                              ? const Color(0xFF12A1BC) // azul “seguir”
                              : const Color(0xFF31B14F), // verde aceptar
                          onPressed: onAccept,
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
          // Cinta superior
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
  const _CategoryChip({
    required this.label,
    required this.icon,
    this.selected = false,
  });

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
  const _PrimaryButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

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

/// ---------- Modal de Detalle (Figura 1) ----------
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
      // Fondo oscuro
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Stack(
        children: [
          // Capa oscura
          GestureDetector(
            onTap: () => Navigator.pop(context, false),
            child: Container(color: Colors.black.withOpacity(.5)),
          ),
          // Tarjeta
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
                  // Header con back y ayuda
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2F3D0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.backpack_rounded, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          short,
                          style: TextStyle(
                            color: Colors.black.withOpacity(.72),
                          ),
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

/// ---------- Diálogo de Confirmación (Figura 2) ----------
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
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w900)),
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
