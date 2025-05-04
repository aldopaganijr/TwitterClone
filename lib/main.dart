import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Twitter Clone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _signInKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Enter an Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an email";
                } else if (!emailValid.hasMatch(value)) {
                  return "Enter valid email address";
                }
                return null;
              },
            ), //email
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Enter a Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password";
                } else if (value.length < 6) {
                  return "Password must be atleast 6 characters";
                }
                return null;
              },
            ), //password
            ElevatedButton(
              onPressed: () {
                if (_signInKey.currentState!.validate()) {
                  debugPrint("Email: ${_emailController.text}");
                  debugPrint("Password: ${_passwordController.text}");
                }
              },
              child: const Text('submit'),
            ),
          ],
        ),
      ),
    );
  }
}
