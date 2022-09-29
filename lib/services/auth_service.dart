import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfirebase/services/firebase_auth_remote_data_source.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
  }

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
  }

  signOut(User? user) async {
    if (user != null) {
      if (user.uid.contains("kakao:")) {
        print("signOutWithKakao");
        await signOutWithKakao();
      }
      if (user.providerData.isNotEmpty) {
        for (var e in user.providerData) {
          if (e.providerId == 'google.com') {
            print("signOutWithGoogle");
            await signOutWithGoogle();
          }
        }
      }
    }
    print("signOut Firebase");
    await _auth.signOut();
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  Future signOutWithGoogle() async {
    await GoogleSignIn().signOut();
  }

  Future signInWithKakao() async {
    bool installed = await kakao.isKakaoTalkInstalled();
    if (installed) {
      await kakao.UserApi.instance.loginWithKakaoTalk();
    } else {
      await kakao.UserApi.instance.loginWithKakaoAccount();
    }
    final user = await kakao.UserApi.instance.me();
    print("user $user");
    print("user.kakaoAccount ${user.kakaoAccount}");
    final token = await FirebaseAuthRemoteDataSource().createCustomToken({
      'uid': user!.id.toString(),
      'displayName': user!.kakaoAccount!.profile!.nickname,
      'email': user!.kakaoAccount!.email!,
      'emailVerified': user!.kakaoAccount!.isEmailVerified.toString()
      // 'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
    });
    print("token $token");
    await FirebaseAuth.instance.signInWithCustomToken(token);
  }

  Future signOutWithKakao() async {
    await kakao.UserApi.instance.unlink();
  }

}
