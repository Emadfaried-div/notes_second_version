import 'package:firebase_core/firebase_core.dart';
import 'package:trials2/firebase_options.dart';
import 'package:trials2/services/auth/auth_user.dart';
import 'package:trials2/services/auth/auth_provider.dart';
import 'package:trials2/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth,FirebaseAuthException ;
class FirebaseAuthProvider implements AuthProvider{
  @override
    Future<AuthUser> createUser({required String email,
      required String password,
    }) async{
      try{
         await FirebaseAuth.instance.createUserWithEmailAndPassword(
           email: email,
           password: password,
         );
           final user = currentUser;
           if (user != null){
             return user;
           }else{
             throw UserNotLoggedINAuthException();
           }
          }on FirebaseAuthException catch (e){

            if (e.code == "weak-password") {
              throw WeakPasswordAuthException();

            } else if (e.code == "email-already-in-use") {

            throw EmailAlreadyInUseAuthException();
            } else if (e.code == "invalid-email") {
            throw InvalidEmailAuthException();
            }else {
              // Handle other FirebaseAuthException codes or generic error
               // Use `await` if necessary
              throw GenericAuthException();
            }

          }catch(_){     //} on FireBaseAuthException
        throw GenericAuthException();
      }
        }//async

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
  final user= FirebaseAuth.instance.currentUser;
  if(user != null ){
  return AuthUser.fromFirebase(user);
  }else{
    return null;
  }
  }

  @override
  Future<AuthUser> lgoIn({
    required String email,
    required String password,
  }) async{
   try{
     await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
     final user = currentUser;
     if (user != null){
       return user;
     }else{
       throw UserNotLoggedINAuthException();
     }

   }on FirebaseAuthException catch (e){
     if (e.code == "user-not-found") {
        throw UserNotFoundAuthException();
     } else if (e.code == "wrong-password") {
        throw WrongPasswordAuthException();
     } else {
        throw GenericAuthException();
     }
   } catch (_){
     throw GenericAuthException();
   }
  }

  @override
  Future<void> logOut() async{
   final user = FirebaseAuth.instance.currentUser;
   if (user != null){
     FirebaseAuth.instance.signOut();
   }else{
     throw UserNotLoggedINAuthException();}
  }

  @override
  Future<void> sendEmailVerificatoin() async{
    final user =FirebaseAuth.instance.currentUser;
    if(user != null ){
      await user.sendEmailVerification();
    }else{
      throw UserNotLoggedINAuthException();
    }
  }

  @override
  Future<void> initialize() async {
     await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

}