import 'package:body_detection_example/providers/counter_model.dart';
import 'package:flutter/material.dart';

double calcularPendiente(Offset punto1, Offset punto2) {
  // Calcular la diferencia en las coordenadas x y y
  double deltaY = (punto2.dy - punto1.dy);
  double deltaX = (punto2.dx - punto1.dx);
  /* print('xA: ${punto1.dx}');
  print('yA: ${punto1.dy}');
  print('xB: ${punto2.dx}');
  print('yB: ${punto2.dy}'); */
  // Evitar la división por cero si deltaX es muy pequeño
  if (deltaX.abs() < 1e-6) {
    // En este caso, la pendiente es infinita
    return double.infinity;
  }

  // Calcular la pendiente usando la fórmula: pendiente = deltaY / deltaX
  double pendiente = deltaY / deltaX;

  return pendiente;
}

PushUpState? isPushUp(Offset puntoA,Offset puntoB,Offset puntoC,PushUpState current) {
  double pendienteAB = calcularPendiente(puntoA, puntoB);
  double pendienteBC = calcularPendiente(puntoB, puntoC);
  print('Pendiente AB: ${pendienteAB.toStringAsFixed(2)}');
  print('Pendiente BC: ${pendienteBC.toStringAsFixed(2)}');
  // Define un umbral para distinguir entre "muy cerrado" y "un poco cerrado".
  double umbral = 0.9; // Puedes ajustar este valor según tus necesidades.

  if(-4.00 < pendienteAB && pendienteAB < -1.90 && pendienteBC > 4.00 && pendienteBC < 20.00 && current == PushUpState.neutral) {
    return PushUpState.init;    
  } else if(pendienteAB > -0.6 && pendienteAB < -0.1  && pendienteBC > 0.4 && pendienteBC < 1.5 && current == PushUpState.init){
    print('NO UNTIL');
    return PushUpState.middleArms;
  } else if(pendienteAB > 0.0 && pendienteAB < 0.49 && pendienteBC > -1.50 && pendienteBC <-0.4 && current == PushUpState.middleArms){
    print('is complete!!!!');
    return PushUpState.complete;
  }
}
