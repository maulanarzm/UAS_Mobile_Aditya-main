// import 'dart:async';

// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ebook_app/src/common/common.dart';

// @RoutePage()
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   void startTimeout() {
//     Timer(const Duration(seconds: 2), handleTimeout);
//   }

//   void handleTimeout() {
//     changeScreen();
//   }

//   Future<void> changeScreen() async {
//     context.router.replace(const TabsRoute());
//   }

//   @override
//   void initState() {
//     super.initState();
//     startTimeout();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image.asset(
//               'assets/images/app-icon.png',
//               height: 300.0,
//               width: 300.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ebook_app/src/features/splash/presentation/ui/screens/create.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isObscure = true; // Variabel untuk mengontrol visibilitas teks password

  Future<void> changeScreen() async {
    context.router.replace(const TabsRoute());
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images2/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images2/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images2/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images2/clock.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(2, 120, 255, 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(42, 52, 255, 0.2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(2, 120, 255, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email or Phone number",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText:
                                    _isObscure, // Menggunakan variabel untuk mengontrol visibilitas teks password
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscure
                                        ? Icons.visibility
                                        : Icons
                                            .visibility_off), // Ikonya akan berubah sesuai dengan visibilitas teks password
                                    onPressed: () {
                                      setState(() {
                                        _isObscure =
                                            !_isObscure; // Mengubah nilai variabel saat tombol diklik
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: GestureDetector(
                        onTap: () {
                          signIn(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(10, 101, 238, 1),
                                Color.fromRGBO(5, 134, 255, 0.6),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: GestureDetector(
                        onTap: () {
                          _goToCreateAccountPage();
                        },
                        child: Text(
                          "Create Account?",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(46, 110, 250, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signIn(BuildContext context) async {
    try {
      // Panggil fungsi signInWithEmailAndPassword untuk masuk dengan email dan password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      print('User berhasil masuk: ${userCredential.user!.email}');
      changeScreen();
      // Navigasi ke halaman MyApp
      // Navigator.pushReplacementNamed(context, '/myapp');
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

  void _goToCreateAccountPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CreateAccountScreen()),
    );
  }
}
