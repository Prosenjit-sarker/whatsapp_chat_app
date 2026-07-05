import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _phoneKey = 'auth_phone';
  static const String _nameKey = 'auth_name';
  static const String _userIdKey = 'auth_user_id';
  static const String _accountsKey = 'saved_accounts';

  static String normalizePhone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    return digits.isEmpty ? input.trim() : digits;
  }

  static String generateUserId(String phone) {
    final normalized = normalizePhone(phone);
    return md5.convert(normalized.codeUnits).toString();
  }

  static Future<void> saveSession(String phone, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedPhone = normalizePhone(phone);
    final userId = generateUserId(normalizedPhone);

    await prefs.setString(_phoneKey, normalizedPhone);
    await prefs.setString(_nameKey, name.trim());
    await prefs.setString(_userIdKey, userId);
    await saveAccount(normalizedPhone, name.trim());
  }

  static Future<void> saveAccount(String phone, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedPhone = normalizePhone(phone);
    final userId = generateUserId(normalizedPhone);
    final accounts = await getAccounts();

    final existingIndex = accounts.indexWhere((account) => account['phone'] == normalizedPhone);
    final account = {'phone': normalizedPhone, 'name': name.trim(), 'userId': userId};

    if (existingIndex >= 0) {
      accounts[existingIndex] = account;
    } else {
      accounts.add(account);
    }

    await prefs.setStringList(
      _accountsKey,
      accounts.map((entry) => '${entry['phone']}|${entry['name']}|${entry['userId']}').toList(),
    );
  }

  static Future<List<Map<String, String>>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_accountsKey) ?? <String>[];
    return raw.map((value) {
      final parts = value.split('|');
      return {
        'phone': parts.isNotEmpty ? parts[0] : '',
        'name': parts.length > 1 ? parts[1] : '',
        'userId': parts.length > 2 ? parts[2] : '',
      };
    }).toList();
  }

  static Future<Map<String, String>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'phone': prefs.getString(_phoneKey) ?? '',
      'name': prefs.getString(_nameKey) ?? '',
      'userId': prefs.getString(_userIdKey) ?? '',
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_userIdKey);
  }

  static Future<void> logout() async {
    await clearSession();
  }
}
