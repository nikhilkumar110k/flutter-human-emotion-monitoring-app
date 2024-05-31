import 'package:flutter/material.dart';
import 'package:onlycode/components/constants.dart';
import 'package:onlycode/components/segmented_control.dart';
import 'package:onlycode/components/custom_buttons.dart';
import 'screen2.dart';
import 'screen4.dart';

class WelcomeScreen3 extends StatelessWidget {
  static String id = 'WelcomeScreen3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Image(
                image: AssetImage('images/3.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Discover Serenity: Your Sanctuary for Mental Health',
                textAlign: TextAlign.center,
                style: kWelcomeHeadingText,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dx > sensitivity) {
                  // Right Swipe
                  Navigator.pushReplacementNamed(context, WelcomeScreen2.id);
                } else if (details.delta.dx < -sensitivity) {
                  //Left Swipe
                  Navigator.pushReplacementNamed(context, WelcomeScreen4.id);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                child: Container(
                  height: 250.0,
                  decoration: kBottomContainer,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: SegmentedControl(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 40.0),
                        child: Text(
                          "Guiding You Towards Inner Peace and Emotional Resilience.",
                          textAlign: TextAlign.center,
                          style: kWelcomeText,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 15.0),
                            child: CustomButton(
                              text: 'Skip',
                              backgroundColor: MaterialStatePropertyAll(
                                Colors.white.withOpacity(0.3),
                              ),
                              textColor: Colors.white,
                              destination: WelcomeScreen4.id,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 20.0),
                            child: CustomButton(
                              text: 'Next',
                              backgroundColor: MaterialStatePropertyAll(
                                Colors.white,
                              ),
                              textColor: Color(0xFF1E1D2E),
                              destination: WelcomeScreen4.id,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
