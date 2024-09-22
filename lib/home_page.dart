
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Custom header with Buddha image and text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Column(
                children: [
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: const [
                  //       Icon(Icons.network_cell),
                  //       SizedBox(width: 8),
                  //       Icon(Icons.battery_std),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ပါမောက္ခချုပ်ဆရာတော် ဘုရားကြီး",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            "ဒေါက်တာ နန္ဒမာလာဘိဝံသ ၏",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "တရားဒေသနာတော်များ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      // const Image(
                      //   image: AssetImage('assets/buddha.jpg'), // Your Buddha image here
                      //   height: 80,
                      // ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Ye Htut Oo မှ ပူဇော်ရေးသားသည်",
                    style: TextStyle(color: Colors.yellow, fontSize: 16),
                  ),
                ],
              ),
            ),
            // Grid layout for the buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                children: [
                  _buildGridItem(Icons.music_note, 'တရားတော်များ'),
                  _buildGridItem(Icons.headset, 'မေတ္တာဉာဏ်တရားတော်များ'),
                  _buildGridItem(Icons.book, 'မေတ္တာအုပ်များ'),
                  _buildGridItem(Icons.self_improvement, 'ဘာသာရိကန်န်တော်မှိုင်း'),
                  _buildGridItem(Icons.video_library, 'တစ်ကိုယ်ရိုက်တော်လှန်ခြင်း'),
                  _buildGridItem(Icons.radio, 'အင်္ဂလိပ်ရေးဒါ'),
                ],
              ),
            ),
            // Row with profile thumbnails
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/monk1.jpg'), // Replace with your image
                    radius: 30,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/monk2.jpg'), // Replace with your image
                    radius: 30,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/monk3.jpg'), // Replace with your image
                    radius: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
