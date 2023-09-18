import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'package:body_detection_example/pose_mask_painter.dart';
import 'package:body_detection_example/providers/counter_model.dart';
import 'package:body_detection_example/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/models/pose.dart';
import 'package:provider/provider.dart';

class ImageDetectionView extends StatefulWidget {
  final Image? selectedImage;
  final Pose? detectedPose;
  final ui.Image? maskImage;
  final Size imageSize;
  final VoidCallback selectImage;
  final VoidCallback detectImagePose;
  final VoidCallback detectImageBodyMask;
  final VoidCallback resetState;
  const ImageDetectionView({
    Key? key,
    required this.selectedImage,
    required this.selectImage,
    required this.detectImagePose,
    required this.detectImageBodyMask,
    required this.resetState,
    required this.detectedPose,
    required this.maskImage,
    required this.imageSize
  }) : super(key: key);

  @override
  State<ImageDetectionView> createState() => _ImageDetectionViewState();
}

class _ImageDetectionViewState extends State<ImageDetectionView> {
  
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
  void didUpdateWidget(ImageDetectionView oldWidget) {
    if(widget.detectedPose != oldWidget.detectedPose) {
      final counterBloC = Provider.of<CounterBloC>(context);
     updatePosition();
     final res = isPushUp(p1!,p2!,p3!,counterBloC.currentPose);
     if(res == PushUpState.complete) {
      Future.delayed(const Duration(milliseconds: 500),
        () {
          counterBloC.increment();
          print(counterBloC.currentPose);
          print('res: ${res}');
          counterBloC.setCurrentPose(PushUpState.neutral);
        }
      );
     } else if(res != null) {
          Future.delayed(const Duration(milliseconds: 500),
            () {
              print(counterBloC.currentPose);
              print('res: ${res}');
              counterBloC.setCurrentPose(res!);
            }
          );
     }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final counterBloc = Provider.of<CounterBloC>(context,listen: false);
    return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                child: ClipRect(
                  child: CustomPaint(
                    child: widget.selectedImage,
                    foregroundPainter: PoseMaskPainter(
                      pose: widget.detectedPose,
                      mask: widget.maskImage,
                      imageSize: widget.imageSize,
                    ),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: widget.selectImage,
                child: const Text('Select image'),
              ),
              OutlinedButton(
                onPressed: widget.detectImagePose,
                child: const Text('Detect pose'),
              ),
              OutlinedButton(
                onPressed: widget.detectImageBodyMask,
                child: const Text('Detect body mask'),
              ),
              OutlinedButton(
                onPressed: () {
                  counterBloc.increment();
                  widget.resetState();
                },
                child: const Text('Clear'),
              ),
              Consumer<CounterBloC>(
                builder:(_,value,child) => Text('Contador\n${value.counter}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}