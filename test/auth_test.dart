import 'package:test/test.dart';
import 'package:trials2/services/auth/auth_exceptions.dart';
import 'package:trials2/services/auth/auth_provider.dart';
import 'package:trials2/services/auth/auth_user.dart';

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
//  @override
//   Future<AuthUser> createUser({
//     required String email,
//     required String password,
//   }) async {
//     // Simulate user creation logic
//     await Future.delayed(const Duration(seconds: 1));

//     if (email.contains("@verified.com")) {
//       return AuthUser(isEmailVerified: true); // Return verified user
//     } else {
//       return AuthUser(isEmailVerified: false); // Return unverified user
//     }
//   }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return const AuthUser(isEmailVerified: false);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "emadfaried@gmail.com") throw UserNotFoundAuthException();
    if (password == "emademad") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerificatoin() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    test("should not be initialized to begin with ", () {
      expect(provider.isInitialized, false);
    });
    test("can't log out if not initialized", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
      test("should be able to be initialized", () async {
        await provider.initialize();
        expect(provider.initialize(), true);
      });
      test("user should be null after initialization", () {
        expect(provider.currentUser, null);
      });
      test("user should be initialized in less than 2 seconds", () async {
        await provider.initialize();
        expect(provider.initialize(), true);
      });
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("create user should delegate to logIn function", () async {
      final badEmailUser = await provider.createUser(
        email: "emadfaried@gmail.com",
        password: "anypassword",
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = await provider.createUser(
        email: "someone@gmail.com",
        password: "emademad",
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "emadfar",
        password: "emademad",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test("logged in user should be able to get verified ", () {
      provider.sendEmailVerificatoin();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test("should be able to log out and login again", () async {
      await provider.logOut();
      await provider.login(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}
