import 'package:_4_guess_number/generated.dart';
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
            onPressed: () {},
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().decrement();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text('Length: ${state.number}'),
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().increment();
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().attemptsDecrement();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text('Attempts: ${state.attempts}'),
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().attemptsIncrement();
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().rightNumbersLengthDecrement();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text('Right answers: ${state.rightNumbersLength}'),
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().rightNumbersLengthIncrement();
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
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
    emit(state.copyWith(
      number: state.number - 1,
      rightNumbersLength: state.rightNumbersLength + 2 > state.number ? state.number - 2 : null,
    ));
  }

  void attemptsIncrement() {
    if (state.attempts >= state.number - state.attempts) return;
    emit(state.copyWith(attempts: state.attempts + 1));
  }

  void attemptsDecrement() {
    if (state.attempts <= 1) return;
    emit(state.copyWith(attempts: state.attempts - 1));
  }

  void rightNumbersLengthIncrement() {
    if (state.rightNumbersLength == state.number - 1) return;
    emit(state.copyWith(rightNumbersLength: state.rightNumbersLength + 1));
  }

  void rightNumbersLengthDecrement() {
    if (state.rightNumbersLength <= 1) return;
    emit(state.copyWith(rightNumbersLength: state.rightNumbersLength - 1));
  }
}

class HomeState {
  HomeState({
    this.number = 9,
    this.attempts = 4,
    this.rightNumbersLength = 5,
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
