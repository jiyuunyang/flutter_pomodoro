import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  int totalPomodoros = 0;
  late Timer timer;

  // 매 초마다 변수 값 변경
  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  // 시작 버튼을 누를 때
  void onStartPressed() {
    // 주기마다 함수를 실행. 1초마다 실행함
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
    setState(() {
      isRunning = true;
    });
  }

  // 정지 버튼을 누를 때
  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  // 리셋 버튼을 누를 때
  void resetPressed() {
    timer.cancel();

    setState(() {
      isRunning = false;
      totalSeconds = twentyFiveMinutes;
    });
  }

  // 초를 00:00 형식으로 변환
  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(format(totalSeconds),
                      style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 89,
                          fontWeight: FontWeight.w600)),
                )),
            Flexible(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          iconSize: 120,
                          color: Theme.of(context).cardColor,
                          onPressed:
                              isRunning ? onPausePressed : onStartPressed,
                          icon: Icon(isRunning
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline)),
                      twentyFiveMinutes != totalSeconds
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  highlightColor: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {
                                    resetPressed();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Row(
                                      children: [
                                        const Text('RESET',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                        IconButton(
                                          iconSize: 30,
                                          color: Colors.black,
                                          onPressed: resetPressed,
                                          icon: const Icon(
                                              Icons.refresh_outlined),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(
                              height: 58,
                            ),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(50),
                                topLeft: Radius.circular(50))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Pomodoros',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color)),
                              Text('$totalPomodoros',
                                  style: TextStyle(
                                      fontSize: 58,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color)),
                            ]),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
