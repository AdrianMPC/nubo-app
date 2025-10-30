import 'package:flutter/material.dart';

class MissionsPage extends StatefulWidget {
  static const String name = 'missions_page';
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  int selectedCategory = 1; // 0: Reciclaje, 1: Empresas, 2: Prendas

  @override
  Widget build(BuildContext context) {
    final colorSeed = const Color(0xFF39B5A8);
    final acceptColor = const Color(0xFF31B14F);
    final specialColor = const Color(0xFFFFA726);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text('Misiones',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Racha ---
              _StreakCard(
                streak: 10,
                accent: colorSeed,
              ),
              const SizedBox(height: 16),

              // --- Recompensa especial ---
              _SpecialRewardCard(
                title: '¡Realiza tu Eco Quiz!',
                subtitle:
                    'Aprende sobre el reciclaje y gana puntos mientras lo haces.',
                reward: 100,
                accent: specialColor,
                onAccept: () {
                  // TODO: acción de aceptar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Eco Quiz aceptado')),
                  );
                },
              ),
              const SizedBox(height: 12),

              // --- Chips de categorías ---
              Row(
                children: [
                  _CategoryChip(
                    label: 'Reciclaje',
                    icon: Icons.eco_rounded,
                    selected: selectedCategory == 0,
                    onTap: () => setState(() => selectedCategory = 0),
                    selectedColor: colorSeed,
                  ),
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: 'Empresas',
                    icon: Icons.bolt_rounded,
                    selected: selectedCategory == 1,
                    onTap: () => setState(() => selectedCategory = 1),
                    selectedColor: colorSeed,
                  ),
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: 'Prendas',
                    icon: Icons.checkroom_rounded,
                    selected: selectedCategory == 2,
                    onTap: () => setState(() => selectedCategory = 2),
                    selectedColor: colorSeed,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- Lista de misiones ---
              _MissionCard(
                title: 'Recicla objetos sólidos',
                description:
                    'plásticos, latas, papel, bolsa, cartón, vidrios, cable',
                reward: 80,
                onAccept: () => _accepted(context, 'Recicla objetos sólidos'),
                acceptColor: acceptColor,
              ),
              _MissionCard(
                title: 'Reciclaje en la familia',
                description:
                    'Logra que un miembro de tu familia recicle contigo y súbanlo juntos',
                reward: 80,
                onAccept: () => _accepted(context, 'Reciclaje en la familia'),
                acceptColor: acceptColor,
              ),
              _MissionCard(
                title: 'Reciclaje en casa',
                description:
                    'Crea un rincón en tu casa para almacenar reciclaje y muéstralo.',
                reward: 80,
                onAccept: () => _accepted(context, 'Reciclaje en casa'),
                acceptColor: acceptColor,
              ),
              _MissionCard(
                title: 'Plantas eco-friendly',
                description:
                    'Convierte una botella plástica o lata en una maceta pequeña y compártela.',
                reward: 80,
                onAccept: () => _accepted(context, 'Plantas eco-friendly'),
                acceptColor: acceptColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _accepted(BuildContext context, String mission) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Misión aceptada: $mission')),
    );
  }
}

/// ------------------ Widgets ------------------

class _StreakCard extends StatelessWidget {
  final int streak;
  final Color accent;
  const _StreakCard({required this.streak, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _glassCard(),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('¡Sigue tu racha!',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.local_fire_department_rounded,
              color: Colors.orange.shade700, size: 28),
          const SizedBox(width: 6),
          Text(
            '$streak',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
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
  final Color accent;
  final VoidCallback onAccept;

  const _SpecialRewardCard({
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.accent,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cinta superior
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
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
                          style: TextStyle(
                            color: Colors.black.withOpacity(.7),
                          )),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '$reward ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                          const Icon(Icons.monetization_on_outlined, size: 20),
                          const Spacer(),
                          _AcceptButton(onPressed: onAccept),
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

class _MissionCard extends StatelessWidget {
  final String title;
  final String description;
  final int reward;
  final VoidCallback onAccept;
  final Color acceptColor;

  const _MissionCard({
    required this.title,
    required this.description,
    required this.reward,
    required this.onAccept,
    required this.acceptColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: _glassCard(),
      padding: const EdgeInsets.all(16),
      child: Row(
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
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.black.withOpacity(.7)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '$reward ',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const Icon(Icons.monetization_on_outlined, size: 20),
                    const Spacer(),
                    _AcceptButton(onPressed: onAccept),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AcceptButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _AcceptButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF31B14F),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: const Text('Aceptar'),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? selectedColor.withOpacity(.12) : Colors.white,
          border: Border.all(
              color: selected ? selectedColor : Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (!selected)
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? selectedColor : null),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? selectedColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estilo común de tarjeta “vidriada”
BoxDecoration _glassCard() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
