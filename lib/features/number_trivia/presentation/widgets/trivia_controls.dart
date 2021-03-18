import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputString;

  _onInputChange(String value) {
    inputString = value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input a number',
            ),
            onChanged: _onInputChange,
            onSubmitted: (_) => _dispatchEvent(
              context: context,
              event: GetTriviaForConcreteNumber(inputString),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text('Search'),
                onPressed: () => _dispatchEvent(
                  context: context,
                  event: GetTriviaForConcreteNumber(inputString),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).accentColor),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: Text(
                  'Get random trivia',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => _dispatchEvent(
                  context: context,
                  event: GetTriviaForRandomNumber(),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).buttonColor),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _dispatchEvent({
    @required BuildContext context,
    @required NumberTriviaEvent event,
  }) {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(event);
  }
}
