import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:twitter_clone/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Login, test for tweet, Log Out', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    Finder loginText = find.text('Log in to Twitter');
    expect(loginText, findsOneWidget);

    Finder loginEmail = find.byKey(ValueKey('loginEmail'));
    Finder loginPassword = find.byKey(ValueKey('loginPassword'));
    Finder loginButton = find.byKey(ValueKey('loginButton'));
    Finder profilePic = find.byKey(ValueKey('profilePic'));
    Finder signOut = find.byKey(ValueKey('signOut'));

    await tester.enterText(loginEmail, 'aldo4@gmail.com');
    await tester.enterText(loginPassword, '123456');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    Finder tweetName = find.text('Aldo');
    expect(tweetName, findsOneWidget);

    await tester.tap(profilePic);
    await tester.pumpAndSettle();

    await tester.tap(signOut);
    await tester.pumpAndSettle();

    expect(loginText, findsOneWidget);
  });
}
