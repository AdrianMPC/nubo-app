import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/controller/usuario_controller.dart';

class HomeTopStatsRowContainer extends StatelessWidget {
  const HomeTopStatsRowContainer({super.key});

  String sanitizeNumber(String? input) {
    if (input == null) return '0';
    final n = int.tryParse(input);
    return n?.toString() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    final controller = UserController();
    
    return StreamBuilder<String>(
      stream: controller.coinsStream(),
      builder: (context, coinsSnapshot) {
        final coins = sanitizeNumber(coinsSnapshot.data);

        return FutureBuilder<String>(
          future: controller.computeStreakAsString(),
          builder: (context, streakSnapshot) {
            final streak = sanitizeNumber(streakSnapshot.data);

            return _HomeTopStatsRow(
              rank: '-',      // TODO: VER RANKING
              coins: coins,
              streak: streak,
            );
          },
        );
      },
    );
  }
}

class _HomeTopStatsRow extends StatelessWidget {
  const _HomeTopStatsRow({
    required this.rank,
    required this.coins,
    required this.streak,
  });

  final String rank;
  final String coins;
  final String streak;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TopItem(
            svgPath: leaderboardSvg,
            value: rank,
          ),
          _TopItem(
            svgPath: nuboCoinSvg,
            value: coins,
          ),
          _TopItem(
            svgPath: streakSvg,
            value: streak,
          ),
        ],
      ),
    );
  }
}

class _TopItem extends StatelessWidget {
  const _TopItem({
    required this.svgPath,
    required this.value,
  });

  final String svgPath;
  final String value;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final iconSize = w * 0.065;

    return Row(
      children: [
        SvgPicture.asset(
          svgPath,
          width: iconSize,
          height: iconSize,
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: w * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
