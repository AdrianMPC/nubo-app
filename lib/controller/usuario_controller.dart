import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nubo/services/auth_service.dart';

class UserController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream en tiempo real para coins
  Stream<String> coinsStream() {
    final user = AuthService.currentUser;
    if (user == null) return Stream.value('0');

    return _db
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return '0';
          final wallet = doc.data()?['wallet'];
          if (wallet is Map<String, dynamic>) {
            final coins = wallet['coins'];
            return coins?.toString() ?? '0';
          }
          return '0';
        });
  }

  // necesitamos calculadr streak, solo una vez
  Future<String> computeStreakAsString() async {
    final user = AuthService.currentUser;
    if (user == null) return '0';
    // 1) Traemos TODOS los días de misión del usuario
    final snap = await _db
        .collection('users')
        .doc(user.uid)
        .collection('mission_days')
        .get();

    if (snap.docs.isEmpty) return '0';
    final dayKeys = snap.docs.map((d) => d.id).toSet();
    final nowLocal = DateTime.now();
    int streak = 0;
    var current = nowLocal;

    while (true) {
      final key = DateFormat('yyyy-MM-dd').format(current);

      if (!dayKeys.contains(key)) {
        break;
      }

      streak++;
      current = current.subtract(const Duration(days: 1));
    }

    return streak.toString();
  }
}
