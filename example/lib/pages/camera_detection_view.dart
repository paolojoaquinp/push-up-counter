import 'dart:math' as math;

import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'package:body_detection_example/providers/counter_bloc.dart';
import 'package:body_detection_example/providers/counter_model.dart';
import 'package:body_detection_example/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../pose_mask_painter.dart';


class CameraDetectionView extends StatefulWidget {
  final Image? cameraImage;
  final Pose? detectedPose;
  final ui.Image? maskImage;
  final Size imageSize;
  final bool isDetectingPose;
  final VoidCallback toggleDetectPose;
  final bool isDetectingBodyMask;
  final VoidCallback toggleDetectBodyMask;
  
  const CameraDetectionView({
    Key? key,
    required this.cameraImage,
    required this.detectedPose,
    required this.maskImage,
    required this.imageSize,
    required this.isDetectingPose,
    required this.toggleDetectPose,
    required this.toggleDetectBodyMask,
    required this.isDetectingBodyMask,
  }) : super(key: key);

  @override
  State<CameraDetectionView> createState() => _CameraDetectionViewState();
}

class _CameraDetectionViewState extends State<CameraDetectionView> {
  Offset? p1;
  Offset? p2;
  Offset? p3;

  Offset offsetForPart(PoseLandmark part) {
    final size = MediaQuery.of(context).size;
    final double hRatio =
        widget.imageSize.width == 0 ? 1 : size.width / widget.imageSize.width;
    final double vRatio =
        widget.imageSize.height == 0 ? 1 : size.height / widget.imageSize.height;
    return Offset(part.position.x * hRatio, part.position.y * vRatio);
  }

  void updatePosition() {
    if(widget.detectedPose == null) return;
    for (final part in widget.detectedPose!.landmarks) {
      // Landmark points
      final type = part.type.toString().substring(17);
      if (part.type.isLeftSide) {
        if(type == 'leftShoulder') {
          p1 = offsetForPart(part);
        } else if(type == 'leftElbow') {
          p2 = offsetForPart(part);
        } else if(type == 'leftWrist') {
          p3 = offsetForPart(part);
        }
/*         print('${}  | ${offsetForPart(part).dx.toString()} | ${offsetForPart(part).dy.toString()} |'); */
      } else if (part.type.isRightSide) {

      }
    }
  }


  @override
  void didUpdateWidget(covariant CameraDetectionView oldWidget) {
    if(widget.detectedPose != oldWidget.detectedPose) {
      final counterBloC = Provider.of<CounterBloC>(context);
      final pushUpBloc = BlocProvider.of<PushUpBloc>(context);
     updatePosition();
     final res = isPushUp(p1!,p2!,p3!,pushUpBloc.state);
     if(res == PushUpState.complete) {
          pushUpBloc.increment();
          print(pushUpBloc.state);
          print('res: ${res}');
          pushUpBloc.setCurrentPose(PushUpState.neutral);
     } else if(res != null) {
          print(pushUpBloc.state);
          print('res: ${res}');
          if(res == PushUpState.middleArms) {
            pushUpBloc.increment();
          }
          pushUpBloc.setCurrentPose(res);
     }
    }
    super.didUpdateWidget(oldWidget);
  }
  

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff273338),
      minimumSize: Size(110, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
    final bloc = BlocProvider.of<PushUpBloc>(context);
    return SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: ClipRect(
                  child: CustomPaint(
                    child: widget.cameraImage,
                    foregroundPainter: PoseMaskPainter(
                      pose: widget.detectedPose,
                      mask: widget.maskImage,
                      imageSize: widget.imageSize,
                  
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: 'primary-button',
                      child: ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: widget.toggleDetectPose,
                        child: widget.isDetectingPose
                            ? const Text('Turn off pose detection',style: TextStyle(
                              color: Colors.white
                            ),)
                            : const Text('Turn on pose detection',
                              style: TextStyle(color: Colors.white),
                            ),
                      ),
                    ),
                  /*               OutlinedButton(
                      onPressed: widget.toggleDetectBodyMask,
                      child: widget.isDetectingBodyMask
                          ? const Text('Turn off body mask detection')
                          : const Text('Turn on body mask detection'),
                    ), */
                    Container(
                      width: 70,
                      child: Column(
                        children: [
                          Text('Counter',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(color: Colors.white.withOpacity(0.8),width: 4.0),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: Text('${bloc.counter}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}