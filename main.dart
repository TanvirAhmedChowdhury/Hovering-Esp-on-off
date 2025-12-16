import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(debugShowCheckedModeBanner: false, home: child);
      },

      child: const LedWebScreen(),
    );
  }
}

class LedWebScreen extends StatefulWidget {
  const LedWebScreen({super.key});

  @override
  State<LedWebScreen> createState() => _LedWebScreenState();
}

class _LedWebScreenState extends State<LedWebScreen> {
  bool ledStatus = false;

  void setLed(bool status) {
    setState(() {
      ledStatus = status;
    });

    sendLedRequest(status);
  }

  Future<void> sendLedRequest(bool isOn) async {
    final url = Uri.parse(
      isOn ? "http://192.168.0.118/on" : "http://192.168.0.118/off",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
    } else {
      throw Exception('LED request failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Title
            Text(
              "Led Control Interface",
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),

            SizedBox(height: 10.h),

            /// Current Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Color(0xFF9ca3af), size: 10),
                SizedBox(width: 5),
                Text(
                  "Current Status: "
                  "${ledStatus ? "ON" : "OFF"}",
                  style: TextStyle(color: Color(0xFF9ca3af)),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            /// LED ON Button
            MouseRegion(
              onEnter: (_) => print("Enter LED ON"),
              onExit: (_) => print("Exit LED ON"),
              onHover: (_) => setLed(true),
              child: GestureDetector(
                onTap: () {
                  print("LED ON Clicked");
                  setLed(true);
                },
                child: _boxes(
                  "LED ON",
                  Color(0xFF13ec13),
                  Colors.black,
                  "assets/led_on.png",
                ),
              ),
            ),

            SizedBox(height: 15.h),

            /// LED OFF Button
            MouseRegion(
              onEnter: (_) => print("Enter LED OFF"),
              onExit: (_) => print("Exit LED OFF"),
              onHover: (_) => setLed(false),
              child: GestureDetector(
                onTap: () {
                  print("LED OFF Clicked");
                  setLed(false);
                },
                child: _boxes(
                  "LED OFF",
                  Color(0xFFf44336),
                  Colors.white,
                  "assets/led_off.png",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom Widget for LED Buttons
  Widget _boxes(String text, Color bgColor, Color textColor, String asset) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      height: 50.h,
      width: 70.w,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(asset, height: 24, width: 24),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 6.sp,
            ),
          ),
        ],
      ),
    );
  }
}
