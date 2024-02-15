import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../screens/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();

  Widget inputField(
      String hint, IconData iconData, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          primary: Colors.blue,
          elevation: 8,
          shadowColor: Colors.black87,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context) async {
    try {
      // Panggil fungsi signInWithEmailAndPassword untuk masuk dengan email dan password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      print('User berhasil masuk: ${userCredential.user!.email}');
 
      // Navigasi ke halaman MyApp
      Navigator.pushReplacementNamed(context, '/myapp');
    } catch (e) {
      // Tangani kesalahan saat masuk
      print('Error saat masuk: $e');

           // Jika masuk berhasil
      Fluttertoast.showToast(
        msg: 'Email atau password tidak valid',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color.fromARGB(255, 244, 54, 54),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> createAccount(BuildContext context) async {
    try {
      // Cek apakah email sudah ada di Firestore
      final emailExists = await _firestore
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (emailExists.docs.isNotEmpty) {
        // Jika email sudah ada, tampilkan notifikasi
        Fluttertoast.showToast(
          msg: 'Email sudah terdaftar.\nsilahkan login',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      // Buat akun dengan email dan password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Simpan nama dan email di Firestore
      await _firestore.collection('users').doc(emailController.text).set({
        'name': nameController.text,
        'email': emailController.text,
      });

      // Jika akun berhasil dibuat
      Fluttertoast.showToast(
        msg: 'Akun berhasil dibuat.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigasi ke halaman MyApp
      Navigator.pushReplacementNamed(context, '/myapp');
    } catch (e) {
      // Tangani kesalahan saat membuat akun
      print('Error saat membuat akun: $e');
    }
  }

  @override
  void initState() {
    createAccountContent = [
      inputField('Name', Ionicons.person_outline, nameController),
      inputField('Email', Ionicons.mail_outline, emailController),
      inputField('Password', Ionicons.lock_closed_outline, passwordController),
      loginButton('Sign Up', () => createAccount(context)),
    ];

    loginContent = [
      inputField('Email', Ionicons.mail_outline, emailController),
      inputField('Password', Ionicons.lock_closed_outline, passwordController),
      loginButton('Log In', () => signIn(context)),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 136,
          left: 24,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        ),
      ],
    );
  }
}
