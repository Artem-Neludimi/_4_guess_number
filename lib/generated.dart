import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';

class GeneratedPage extends StatelessWidget {
  const GeneratedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              children: [
                Padding(padding: EdgeInsets.all(16), child: Text('Attempts left:')),
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
                  return Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
