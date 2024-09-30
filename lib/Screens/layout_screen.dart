import 'package:flutter/material.dart';
import 'package:video_player_app/Screens/custom_video_player_from_network_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: const Text("Watch a video"),
          onPressed: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=> const CustomVideoPlayerFromNetworkScreen())),
        ),
      ),
    );
  }
}
