import 'package:trials2/services/auth/auth_user.dart';
import 'package:trials2/services/auth/auth_provider.dart';
import 'package:trials2/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider{

  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase()=> AuthService(FirebaseAuthProvider());
  @override
  Future<AuthUser> createUser(
      {required String email,
        required String password,
      }) => provider.createUser(email: email, password: password,);

  @override

  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> lgoIn({
    required String email,
    required String password,
  })=> provider.lgoIn(email: email, password: password,);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerificatoin()=> provider.sendEmailVerificatoin();

  @override
  Future<void> initialize() => provider.initialize();
}