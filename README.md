# flutter_firebase

## 기본 내용

Flutter에서 Firebase 연동해보는 실험 프로젝트입니다.

2022년 9월29일 현재까지는 아래와 같은 항목을 구현했습니다. (브랜치별 기능 분리)

* firebase-simeple-signin-signup
  - 이메일과 패스워드로 간단한 로그인/회원가입 화면
* firebase-verify-email
  - 최초 로그인할 때에 인증 메일을 보내고, 메일 링크 눌러서 인증해야만 넘어갈 수 있도록 구현
* firebase-google-sign-in
  - 구글 계정으로 소셜 로그인할 수 있도록 구현
* firebase-kakao-login
  - 카카오 계정으로 소셜 로그인할 수 있도록 구현

## 소스 코드 출처

이 저장소 소스의 기본 내용은 아래 링크에서 가져왔습니다.
PacktPublishing  비디오 강의 내용입니다.
이 자리를 빌어 저자인 Varun Nath에게 감사인사 드립니다.

 * [비디오 링크, Flutter Foundation with Firebase and Provider [Video]
By Varun Nath](https://www.packtpub.com/product/flutter-foundation-with-firebase-and-provider/9781804611449?_ga=2.76004373.127952286.1664420772-197058785.1664174451)
 * [소스 코드 링크, Flutter-Foundation-with-Firebase-and-Provider](https://github.com/PacktPublishing/Flutter-Foundation-with-Firebase-and-Provider)

카카오 계정 연동 방법은 오준석님의 비디오 강의를 보며 배웠습니다. 
다시 한 번 감사드립니다.

 * [비디오 링크, Flutter 카카오 로그인 완전 쉬움](https://www.youtube.com/watch?v=Ar6RdDf77xQ&t=17s)
 * [비디오 링크, Flutter 카카오 로그인 Firebase Auth 연동 방법](https://www.youtube.com/watch?v=Akt91Cl_z00)
 * [소스 코드 링크, flutter_kakao_login_guide](https://github.com/junsuk5/flutter-kakao-login-guide/tree/firebase_auth)

## 사전 준비

이 소스를 활용하시려면 대략 아래와 같은 절차가 필요합니다.

### Firebase Project 생성, Flutter App 추가

Firebase Console 사이트 로그인하고, 새로운 프로젝트 생성하고, 아래 명령으로 Flutter App 추가

```
dart pub global activate flutterfire_cli
```

```
flutterfire configure --project=your-project-id-in-firebase
```

위 명령을 실행하면 아래 파일이 생성됩니다..

```
/ios/firebase_app_id_file.json
/lib/firebase_options.dart
```

### SHA 인증서 지문 등록, SHA certificate fingerprints 

구글 계정 연동 로그인 개발과정에서 아래 오류를 만나면 거의 대부분이 이 문제임.
```
I/flutter ( 8413): PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: , null, null)
```

아래 링크 문서에 자세한 내용 나와있음.

* [구글 로그인 PlatformException](https://kyungsnim.net/200)

### Firebase Functions

serviceAccountKey를 생성해서 /functions 폴더 아래에 넣어줌.

Firebase Console 사이트에서 프로젝트를 선택하고, 
Project Settings > Service Account 화면, Firebase Admin SDK 항목, Generate new private key 메뉴 클릭


### .env 파일 생성 및 설정

.env.sample 파일을 복사해서 .env 파일 생성

아래 두 항목을 채워줘야 제대로 작동함.
```
KAKAO_NATIVE_APP_KEY=your_kakao_native_app_key
CREATE_CUSTOM_TOKEN_URL=your_firebase_function
```
KAKAO_NATIVE_APP_KEY 키는 [카카오 개발자 사이트](https://developers.kakao.com/)에서 프로젝트 생성하면 얻을 수 있음.

CREATE_CUSTOM_TOKEN_URL 키는 /functions 폴더에서 아래 명령을 실행해서 서버에 올리면 그 주소를 알아낼 수 있음. 

```
firebase deploy
```

자세한 내용은 오준석님의 비디오 강의 참조.

## KAKAO_NATIVE_APP_KEY 숨기기

오준석님의 소스 코드에는 오준석님이 예제로 사용한 카카오 개발자 앱 네이티브 코드가 두 군데 들어있음.
* main.dart
* android/app/src/main/AndroidManifest.xml

이 값을 소스 코드에 노출하지 않기 위해 방법을 찾아봄.

### manifestPlaceholders 

 * [바로 도움을 주는 고마운 스택오버플로우 링크](https://stackoverflow.com/questions/70906879/attribute-applicationname-at-androidmanifest-xml59-42-requires-a-placeholder)

app/build.gradle 파일에서  manifestPlaceholders 변수로 치환해줄 수 있음.

```
defaultConfig {
    ...
    manifestPlaceholders += [KAKAO_NATIVE_APP_KEY:"a5c090540d61b6"]
}
```

이렇게 지정하면, AndroidManifest.xml 파일에 있는 아래 값이 위에서 지정한 값으로 변환됨.

```
            <intent-filter android:label="flutter_web_auth">
               <action android:name="android.intent.action.VIEW" />
               <category android:name="android.intent.category.DEFAULT" />
               <category android:name="android.intent.category.BROWSABLE" />

               <!-- Redirect URI, "kakao${YOUR_NATIVE_APP_KEY}://oauth" 형식 -->
               <data android:scheme="kakao${KAKAO_NATIVE_APP_KEY}" android:host="oauth"/>
            </intent-filter>
```

하지만, 아직 문제가 모두 해결된 것은 아님. app/build.gradle 파일에는 여전히 그 값이 들어가 있으므로...

### flutter_config 사용

 * [바로 도움을 주는 고마운 스택오버플로우 링크](https://stackoverflow.com/questions/70906879/attribute-applicationname-at-androidmanifest-xml59-42-requires-a-placeholder)
 * [flutter_config 링크](https://pub.dev/packages/flutter_config)


아래와 같이 main.dart 파일에서 KAKAO_NATIVE_APP_KEY 환경변수를 받아서 카카오 SDK init() 함수에 제대로 전달함.
 ```
import 'package:flutter_config/flutter_config.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  final key = FlutterConfig.get('KAKAO_NATIVE_APP_KEY');
  kakao.KakaoSdk.init(nativeAppKey: key);
  runApp(const App());
}
```

다음으로는 app/build.gradle 파일에서 아래와 같이 kakaoNativeAppKey 변수를 써서 깔끔하게 처리함.
```
apply from: project(':flutter_config').projectDir.getPath() + "/dotenv.gradle"

def kakaoNativeAppKey = project.env.get("KAKAO_NATIVE_APP_KEY")


defaultConfig {
    ...
    manifestPlaceholders += [KAKAO_NATIVE_APP_KEY:kakaoNativeAppKey]
}
```

