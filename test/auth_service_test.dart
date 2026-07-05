import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/services/auth_service.dart';
import 'package:whatsapp_clone/services/chat_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('normalizes phone numbers for consistent identity', () {
    expect(AuthService.normalizePhone('+880 1712-345678'), '8801712345678');
    expect(AuthService.normalizePhone('01712345678'), '01712345678');
  });

  test('saves and lists multiple accounts for switching', () async {
    await AuthService.saveAccount('01712345678', 'Alice');
    await AuthService.saveAccount('01812345678', 'Bob');

    final accounts = await AuthService.getAccounts();

    expect(accounts.length, 2);
    expect(accounts.any((account) => account['phone'] == '01712345678' && account['name'] == 'Alice'), isTrue);
    expect(accounts.any((account) => account['phone'] == '01812345678' && account['name'] == 'Bob'), isTrue);
  });

  test('creates a stable conversation room id for two accounts', () {
    expect(ChatService.conversationRoomId('user-b', 'user-a'), 'user-a_user-b');
  });
}
