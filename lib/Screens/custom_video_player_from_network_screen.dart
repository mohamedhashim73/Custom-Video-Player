import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerFromNetworkScreen extends StatefulWidget {
  const CustomVideoPlayerFromNetworkScreen({super.key});

  @override
  State<CustomVideoPlayerFromNetworkScreen> createState() => _CustomVideoPlayerFromNetworkScreenState();
}

class _CustomVideoPlayerFromNetworkScreenState extends State<CustomVideoPlayerFromNetworkScreen> {
  late VideoPlayerController _controller;
  bool showControlTools = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://zain-physics.online/public/app/videos/66fac3bfe9876_820215932.mp4')..initialize()..setLooping(true);
    _controller.play().then((e) async {
      setState(() {});
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    super.dispose();
  }

  Orientation getOrientation(BuildContext context)=> MediaQuery.of(context).orientation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOrientation(context) == Orientation.portrait ? AppBar(title: const Text("Custom Video Player"),backgroundColor: Colors.blue,foregroundColor: Colors.white) : null,
      body: Builder(
        builder: (context){
          if( _controller.value.isInitialized || _controller.value.isPlaying )
          {
            return ListView(
              children: [
                InkWell(
                  onTap: ()=> setState(() {
                    showControlTools = !showControlTools;
                    Future.delayed(const Duration(seconds: 3),(){
                    if( showControlTools == true ) {
                      setState(() {showControlTools = false;});
                    }});
                  }),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          AspectRatio(
                            aspectRatio: MediaQuery.of(context).orientation == Orientation.portrait ? 9/16 : 16/9,
                            child: VideoPlayer(_controller),
                          ),
                          Column(
                            children: [
                              VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor: showControlTools ? Colors.blue : Colors.white,
                                  bufferedColor: Colors.white24,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              if( showControlTools )
                                Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(_controller.value.volume == 1 ? Icons.volume_mute : Icons.volume_up,color: Colors.white),
                                    onPressed: () async {
                                      _controller.value.volume == 0
                                          ? _controller.setVolume(1)
                                          : _controller.setVolume(0);
                                      setState((){});
                                    },
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: Image.asset("assets/backward-5-seconds.png",color: Colors.white,height: 22,width: 22),
                                          onTap: () async {
                                            Duration newPosition = _controller.value.position - const Duration(seconds: 5);
                                            await _controller.seekTo(newPosition);
                                            _controller.value.isPlaying
                                                ? _controller.pause()
                                                : _controller.play();
                                            setState((){});
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.white,size: 22),
                                          onPressed: (){
                                            _controller.value.isPlaying
                                                ? _controller.pause()
                                                : _controller.play();
                                            setState(() {});
                                          },
                                        ),
                                        InkWell(
                                          child: Image.asset("assets/forward-5-seconds.png",color: Colors.white,height: 22,width: 22),
                                          onTap: () async {
                                            Duration newPosition = _controller.value.position + const Duration(seconds: 5);
                                            await _controller.seekTo(newPosition);
                                            _controller.value.isPlaying
                                                ? _controller.pause()
                                                : _controller.play();
                                            setState((){});
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.fullscreen,color: Colors.white),
                                    onPressed: () async {
                                      await SystemChrome.setPreferredOrientations([MediaQuery.of(context).orientation == Orientation.landscape ? DeviceOrientation.portraitUp : DeviceOrientation.landscapeRight]);
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                if( MediaQuery.of(context).orientation == Orientation.portrait )
                  Container(
                      margin: const EdgeInsets.only(top: 22,bottom: 22),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text("Al-Ahly is an Egyptian football club founded and headed in April, 1907 by Mitchell Ince in Cairo, Egypt. The club has risen from popular roots to become one of Africa’s best teams.Al-Ahly best known as the “people’s club”, is believed to have 40 million supporters, making them the most popular clubs in Egypt.The idea of establishing Al-Ahly was initiated by Mitchel Ince. He shared the idea with Edrees Rageb Pasha, Omar Sultan Pasha, Ismaeel Serry, Abdul El Khalek Tharwat, and Ameen Samy. They came together with the idea to establish a club for high school students to spend their spare time. They decided to establish a company with five thousand Egyptian Pounds.On February 25, 1908, Ameen Samy suggested the name Ahly Athletic Club (National Athletic Club), which was founded to contain High School Students who were the main pillars of the resistance against British occupation of Egypt. So, it was founded as an Egyptian national club to unite these students, and named Al-Ahly to represent nationalism with the literal meaning of the word. Ahly is considered the first club founded for Egyptians in Egypt and was established during the British occupation of Egypt.It is to be noted that Saleh Selim (b. September 11, 1930; d. May 6, 2002) was the first football player to become President of al-Ahly Sporting Club in 1980.",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.8)),)
                  )
              ],
            );
          }
          else
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
