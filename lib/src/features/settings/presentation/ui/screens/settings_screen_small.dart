import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/splash/presentation/ui/screens/create.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsScreenSmall extends StatefulWidget {
  const SettingsScreenSmall({Key? key}) : super(key: key);

  @override
  State<SettingsScreenSmall> createState() => _SettingsScreenSmallState();
}

class _SettingsScreenSmallState extends State<SettingsScreenSmall> {
  List<Map<String, dynamic>> items = [];
  late String
      userName; // gunakan late keyword untuk menginisialisasi variabel nanti

  @override
  void initState() {
    super.initState();
    userName = ''; // inisialisasi userName dengan string kosong
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();
      if (snapshot.docs.isNotEmpty) {
        // Periksa apakah ada dokumen dalam hasil query
        setState(() {
          userName = snapshot.docs[0]['name']
              as String; // Akses nama dari dokumen pertama dalam query
        });
      }
    }
    _initializeSettings();
  }

  void _initializeSettings() {
    setState(() {
      items = [
        {
          'icon': Feather.user,
          'title': userName.isNotEmpty ? userName : 'Profile',
          'function': () => _editProfile(),
        },
        {
          'icon': Feather.heart,
          'title': 'Favorites',
          'function': () => _pushPage(const FavoritesRoute()),
        },
        {
          'icon': Feather.download,
          'title': 'Downloads',
          'function': () => _pushPage(const DownloadsRoute()),
        },
        {
          'icon': Feather.moon,
          'title': 'Dark Mode',
          'function': null,
        },
        {
          'icon': Feather.log_out,
          'title': 'Logout',
          'function': () => _logout(),
        },
      ];
    });
  }

  //...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isSmallScreen
          ? AppBar(
              centerTitle: true,
              title: const Text('Settings'),
            )
          : null,
      body: Column(
        children: [
          if (!context.isSmallScreen) const SizedBox(height: 30),
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              if (items[index]['title'] == 'Dark Mode') {
                if (context.isPlatformDarkThemed) {
                  return const SizedBox.shrink();
                }
                return _ThemeSwitch(
                  icon: items[index]['icon'] as IconData,
                  title: items[index]['title'] as String,
                );
              }

              return ListTile(
                onTap: items[index]['function'] as Function(),
                leading: Icon(items[index]['icon'] as IconData),
                title: Text(items[index]['title'] as String),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              if (items[index]['title'] == 'Dark Mode' &&
                  context.isPlatformDarkThemed) {
                return const SizedBox.shrink();
              }
              return const Divider();
            },
          ),
        ],
      ),
    );
  }

  void _logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    // Logika logout berhasil
    Fluttertoast.showToast(
      msg: 'Logout berhasil',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    changeScreen();
    // Setelah logout berhasil, arahkan pengguna ke halaman login
  } catch (e) {
    // Tangani kesalahan saat logout
    print('Error saat logout: $e');
    Fluttertoast.showToast(
      msg: 'Logout gagal',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

  void _editProfile() {
    // Implementasi logika logout di sini
    // Misalnya, bersihkan token autentikasi atau lakukan tindakan logout yang diperlukan.
    // Setelah itu, arahkan pengguna ke halaman login atau halaman awal aplikasi.
  }

 Future<void> changeScreen() async {
    context.router.replace(const SplashRoute());
  }
  void _pushPage(PageRouteInfo route) {
    if (context.isLargeScreen) {
      context.router.replace(route);
    } else {
      context.router.push(route);
    }
  }

  Future<void> showAbout() async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text(
            'OpenLeaf is a Simple ebook app by JideGuru using Flutter',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: context.theme.colorScheme.secondary,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeSwitch extends ConsumerWidget {
  final IconData icon;
  final String title;

  const _ThemeSwitch({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAppTheme = ref.watch(currentAppThemeNotifierProvider);
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      value: currentAppTheme.value == CurrentAppTheme.dark,
      onChanged: (isDarkMode) {
        ref
            .read(currentAppThemeNotifierProvider.notifier)
            .updateCurrentAppTheme(isDarkMode);
      },
    );
  }
}
