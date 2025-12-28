import 'package:flutter/material.dart';

import '../../app/assets.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      await Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final launchSize = (constraints.maxWidth * 0.42).clamp(
              140.0,
              200.0,
            );
            final logoWidth = (constraints.maxWidth * 0.60).clamp(180.0, 260.0);

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: const AssetImage(AppAssets.amongUsLaunch),
                    width: launchSize,
                    height: launchSize,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 18),
                  Image(
                    image: const AssetImage(AppAssets.amongUsLogo),
                    width: logoWidth,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
