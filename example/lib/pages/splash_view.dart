import 'package:body_detection_example/pages/home_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff273338),
      minimumSize: Size(size.width * 0.85, 56),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.15,
            ),
            Container(
                alignment: Alignment.center,
                width: size.width * 0.7,
                height: size.width * 0.7,
                child: Lottie.asset('assets/push-up-animation-2.json',
                    fit: BoxFit.cover)),
            const SizedBox(height: 100),
            const Text(
              'Push Up Counter',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                  fontSize: 38.0),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: const Text(
                'An exciting greeting as your artificial intelligence counts your push ups accurately.',
                textAlign: TextAlign.center,
                style: TextStyle(letterSpacing: -1.1, fontSize: 18.0),
              ),
            ),
            const Spacer(),
            Hero(
              tag: 'primary-button',
              child: ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                  );
                },
                child: const Text('Start now!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: -0.6,
                    )),
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            )
          ],
        ),
      ),
    );
  }
}
