import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(App());

///[MyFirstBloc] MY BLOC WILL MANAGE FIRST DROP DOWN VALUES
///[MySecondBloc] MY BLOC WILL MANAGE FIRST DROP DOWN VALUES

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyFirstBloc>(create: (context) => MyFirstBloc()),
        BlocProvider<MySecondBloc>(create: (context) => MySecondBloc()),
      ],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}

class HomeScreen extends StatelessWidget {
  /// [ScaffoldState] SCAFFOLD STATE IS USED TO MANAGE THE CONTEXT
  /// DO NO TAKE THIS A COMMON USAGE THIS IS ONLY FOR TEST
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: BlocListener<MyFirstBloc, int>(
        /// [listener] LISTENER WITH VALIDATION WILL ADD VALUE IF IT'S INT
        listener: (context, streamValue) => streamValue is int
            ? BlocProvider.of<MySecondBloc>(context).add(streamValue)
            : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            BlocBuilder<MyFirstBloc, int>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /// [DropdownButton] THIS WAS TAKEN FROM FLUTTER DOCS
                    DropdownButton<String>(
                      value: "0",
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: _onChange,
                      items: <int>[0, 1, 2]
                          .map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),

            /// [DropdownButton] THIS IS THE ASYNC DROPDOWN WILL CHANGE VALUES ACCORDING TO FIRST DROPDOWN
            MyDropDown(),
          ],
        ),
      ),
    );
  }

  /// [DropdownButton] THIS IS ONCHANGE FUNCTION TO SET VALUE FOR THE SECOND DROPDOWN
  void _onChange(String value) {
    BlocProvider.of<MyFirstBloc>(_scaffoldState.currentContext)
        .add(int.parse(value));
  }
}

class MyDropDown extends StatefulWidget {
  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String dropDownSelectedValue = '-';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        BlocListener<MySecondBloc, List<String>>(
          listener: (context, state) {
            /// SIMPLE VALIDATION
            /// THIS SHOULD BE TAKEN FROM MAIN FUNCTION
            /// DO NOT DO THIS IS ONLY FOR QUICK TEST PURPOSE
            if (state != null && state.length > 0)
              dropDownSelectedValue = state[0];
          },
          child: BlocBuilder<MySecondBloc, List<String>>(
            builder: (context, state) {
              return DropdownButton(
                items: state.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => dropDownSelectedValue = value),
                value: dropDownSelectedValue,
              );
            },
          ),
        ),
      ],
    );
  }
}

///[MyFirstBloc] BLOC TO MANAGE FIRST DROPDOWN
class MyFirstBloc extends Bloc<int, int> {
  MyFirstBloc() : super(0);
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(int event) async* {
    yield event;
  }
}

///[MySecondBloc] BLOC TO MANAGE SECOND DROPDOWN
class MySecondBloc extends Bloc<int, List<String>> {
  MySecondBloc() : super([]);

  List<String> get initialState => [];

  @override
  Stream<List<String>> mapEventToState(int event) async* {
    List<String> players = [];
    if (event == 0) players = ["Roberto Carlos", "Robinho", "Rivaldo"];
    if (event == 1) players = ["Kaka", "Ronaldiño", "Ronaldo"];
    if (event == 2) players = ["Messi", "Maradona", "Lucas"];

    yield players;
    print('players: $players');
  }
}
