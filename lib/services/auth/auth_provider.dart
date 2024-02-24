import 'package:trials2/services/auth/auth_user.dart';


abstract class AuthProvider{
  Future<void> initialize();
  AuthUser? get currentUser ;
  Future<AuthUser>lgoIn({
    required String email,
    required String password,
      }
      );
  Future<AuthUser>createUser({
    required String email,
    required String password,
      }
      );
  Future<void>logOut();
  Future<void>sendEmailVerificatoin();
}