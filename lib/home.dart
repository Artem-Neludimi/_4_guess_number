import 'package:_4_guess_number/generated.dart';
import 'package:_4_guess_number/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Generate number'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          const Text('Wins'),
                          const Spacer(),
                          Text((prefs.getInt('winCount') ?? 0).toString()),
                        ]),
                        const SizedBox(height: 32),
                        Row(children: [
                          const Text('Losses'),
                          const Spacer(),
                          Text((prefs.getInt('loseCount') ?? 0).toString()),
                        ]),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  context.read<HomeCubit>().decrement();
                },
                icon: const Icon(Icons.arrow_back, size: 40),
              ),
              Text('Length: ${state.number}', style: Theme.of(context).textTheme.displaySmall),
              IconButton(
                onPressed: () {
                  context.read<HomeCubit>().increment();
                },
                icon: const Icon(Icons.arrow_forward, size: 40),
              ),
            ],
          ),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  context.read<HomeCubit>().attemptsDecrement();
                },
                icon: const Icon(Icons.arrow_back, size: 40),
              ),
              Text('Attempts: ${state.attempts}', style: Theme.of(context).textTheme.displaySmall),
              IconButton(
                onPressed: () {
                  context.read<HomeCubit>().attemptsIncrement();
                },
                icon: const Icon(Icons.arrow_forward, size: 40),
              ),
            ],
          ),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  context.read<HomeCubit>().rightNumbersLengthDecrement();
                },
                icon: const Icon(Icons.arrow_back, size: 40),
              ),
              Text('Right answers: ${state.rightNumbersLength}', style: Theme.of(context).textTheme.displaySmall),
              IconButton(
                onPressed: () {
                  context.read<HomeCubit>().rightNumbersLengthIncrement();
                },
                icon: const Icon(Icons.arrow_forward, size: 40),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(value: context.read<HomeCubit>(), child: const GeneratedPage()))),
        tooltip: 'Increment',
        child: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());
  void increment() {
    emit(state.copyWith(number: state.number + 1));
  }

  void decrement() {
    if (state.number <= 2) return;
    final isLogic = _isLogic(state.number - 1, state.attempts, state.rightNumbersLength);
    if (!isLogic) {
      attemptsDecrement();
      rightNumbersLengthDecrement();
    }
    emit(state.copyWith(
      number: state.number - 1,
    ));
  }

  void attemptsIncrement() {
    if (!_isLogic(state.number, state.attempts + 1, state.rightNumbersLength)) return;
    emit(state.copyWith(attempts: state.attempts + 1));
  }

  void attemptsDecrement() {
    if (state.attempts <= 1) return;
    emit(state.copyWith(attempts: state.attempts - 1));
  }

  void rightNumbersLengthIncrement() {
    if (!_isLogic(state.number, state.attempts, state.rightNumbersLength + 1)) return;
    emit(state.copyWith(rightNumbersLength: state.rightNumbersLength + 1));
  }

  void rightNumbersLengthDecrement() {
    if (state.rightNumbersLength <= 1) return;
    emit(state.copyWith(rightNumbersLength: state.rightNumbersLength - 1));
  }

  bool _isLogic(int number, int attempts, int rightNumbersLength) => number > attempts + rightNumbersLength;
}

class HomeState {
  HomeState({
    this.number = 9,
    this.attempts = 1,
    this.rightNumbersLength = 1,
  });

  final int number;
  final int attempts;
  final int rightNumbersLength;

  HomeState copyWith({
    int? number,
    int? attempts,
    int? rightNumbersLength,
  }) {
    return HomeState(
      number: number ?? this.number,
      attempts: attempts ?? this.attempts,
      rightNumbersLength: rightNumbersLength ?? this.rightNumbersLength,
    );
  }
}
