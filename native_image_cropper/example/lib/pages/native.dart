import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_image_cropper/native_image_cropper.dart';
import 'package:native_image_cropper_example/pages/result.dart';
import 'package:native_image_cropper_example/widgets/image_format_dropdown.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key, required this.bytes});

  final Uint8List bytes;

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  ImageFormat _format = ImageFormat.jpg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Image(
              image: MemoryImage(widget.bytes),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageFormatDropdown(
                onChanged: (value) => _format = value,
              ),
              InkWell(
                onTap: () => _cropImage(context, CropMode.rect),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    border: Border.fromBorderSide(BorderSide()),
                  ),
                  child: const Icon(
                    Icons.crop,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _cropImage(context, CropMode.oval),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(),
                    ),
                  ),
                  child: const Icon(
                    Icons.crop,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _cropImage(BuildContext context, CropMode mode) async {
    Uint8List croppedBytes;
    if (mode == CropMode.rect) {
      croppedBytes = await NativeImageCropper.cropRect(
        bytes: widget.bytes,
        x: 1200,
        y: 900,
        width: 600,
        height: 600,
        format: _format,
      );
    } else {
      croppedBytes = await NativeImageCropper.cropOval(
        bytes: widget.bytes,
        x: 1200,
        y: 900,
        width: 600,
        height: 600,
        format: _format,
      );
    }

    if (mounted) {
      return Navigator.push<void>(
        context,
        MaterialPageRoute<ResultPage>(
          builder: (_) => ResultPage(
            bytes: croppedBytes,
            format: _format,
          ),
        ),
      );
    }
  }
}
