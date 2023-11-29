import 'dart:math';

import 'package:_4_guess_number/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';

class GeneratedPage extends StatelessWidget {
  const GeneratedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeCubit>().state;
    return BlocProvider(
      create: (context) =>
          GeneratedCubit(homeState.number, homeState.attempts, homeState.rightNumbersLength)..generate(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Guess the correct number'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bar_chart),
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<GeneratedCubit, GeneratedState>(
              listenWhen: (previous, current) => current.isWin,
              listener: (context, state) {
                showDialog(
                  context: context,
                  builder: (context) => const Dialog(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('You win!'),
                    ),
                  ),
                ).then((value) => Navigator.pop(context));
              },
            ),
            BlocListener<GeneratedCubit, GeneratedState>(
              listenWhen: (previous, current) => current.isLose,
              listener: (context, state) {
                showDialog(
                  context: context,
                  builder: (context) => const Dialog(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('You lose!'),
                    ),
                  ),
                ).then((value) => Navigator.pop(context));
              },
            ),
          ],
          child: const _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GeneratedCubit>().state;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Attempts left: ${state.attemptsLeft}'),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              itemCount: state.number,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return _Item(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatefulWidget {
  const _Item(this.index);

  final int index;

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) => _status = status);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _animation.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    final rightNumbers = context.watch<GeneratedCubit>().state.rightNumbers;
    final isRight = rightNumbers.contains(widget.index);

    return GestureDetector(
      onTap: () {
        if (_status == AnimationStatus.dismissed) {
          _controller.forward();
          context.read<GeneratedCubit>().makeGuess(isRight);
        }
      },
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY(pi * _animation.value),
        child: _animation.value <= 0.5
            ? Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    '${widget.index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              )
            : Container(
                color: isRight ? Colors.green : Colors.red,
                child: Center(
                  child: Transform.flip(
                    flipX: true,
                    child: Text(
                      '${widget.index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class GeneratedCubit extends Cubit<GeneratedState> {
  GeneratedCubit(
    int number,
    int attemptsLeft,
    int rightNumbersLength,
  ) : super(GeneratedState(
          number: number,
          attemptsLeft: attemptsLeft,
          rightNumbersLength: rightNumbersLength,
        ));

  void generate() {
    final random = Random();

    final rightNumbers = <int>[];
    while (rightNumbers.length < state.rightNumbersLength) {
      final number = random.nextInt(state.number);
      if (!rightNumbers.contains(number)) {
        rightNumbers.add(number);
      }
    }
    emit(state.copyWith(
      rightNumbers: rightNumbers,
      rightNumbersGuessLeft: state.rightNumbersLength,
    ));
  }

  void makeGuess(bool isRight) {
    final attemptsLeft = isRight ? state.attemptsLeft : state.attemptsLeft - 1;
    final rightNumbersGuessLeft = isRight ? state.rightNumbersGuessLeft - 1 : state.rightNumbersGuessLeft;
    if (rightNumbersGuessLeft == 0) {
      emit(state.copyWith(isWin: true, attemptsLeft: attemptsLeft));
      prefs.setInt('winCount', (prefs.getInt('winCount') ?? 0) + 1);
      return;
    }
    if (attemptsLeft == 0) {
      emit(state.copyWith(isLose: true, attemptsLeft: attemptsLeft));
      prefs.setInt('loseCount', (prefs.getInt('loseCount') ?? 0) + 1);
      return;
    }
    emit(state.copyWith(
      attemptsLeft: attemptsLeft,
      rightNumbersGuessLeft: rightNumbersGuessLeft,
    ));
  }
}

class GeneratedState {
  const GeneratedState({
    required this.number,
    required this.attemptsLeft,
    required this.rightNumbersLength,
    this.rightNumbers = const [],
    this.rightNumbersGuessLeft = 0,
    this.isWin = false,
    this.isLose = false,
  });

  final int number;
  final int attemptsLeft;
  final int rightNumbersLength;
  final List<int> rightNumbers;
  final int rightNumbersGuessLeft;
  final bool isWin;
  final bool isLose;

  GeneratedState copyWith({
    int? number,
    int? attemptsLeft,
    int? rightNumbersLength,
    List<int>? rightNumbers,
    int? rightNumbersGuessLeft,
    bool? isWin,
    bool? isLose,
  }) {
    return GeneratedState(
      number: number ?? this.number,
      attemptsLeft: attemptsLeft ?? this.attemptsLeft,
      rightNumbersLength: rightNumbersLength ?? this.rightNumbersLength,
      rightNumbers: rightNumbers ?? this.rightNumbers,
      rightNumbersGuessLeft: rightNumbersGuessLeft ?? this.rightNumbersGuessLeft,
      isWin: isWin ?? this.isWin,
      isLose: isLose ?? this.isLose,
    );
  }
}
