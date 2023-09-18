import 'package:flutter/foundation.dart';


enum PushUpState {
  neutral,
  init,
  middleArms,
  complete
}

class CounterBloC with ChangeNotifier {
  int counter = 0;
  PushUpState currentPose = PushUpState.neutral;

  void setCurrentPose(PushUpState value) {
    currentPose = value;
    notifyListeners();
  }

  void increment() {
    counter++;
    notifyListeners();
  }

  void decrement() {
    counter--;
    notifyListeners();
  }
}

/* class MyInheritedWidget extends InheritedWidget {
  final Widget child;
  final CounterBloC? counterBloc;

  const MyInheritedWidget({
    Key? key,
    required this.child,
    this.counterBloc
  }) : super(child: child);

  static MyInheritedWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
 */