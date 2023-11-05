// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../logic/models/config/configurations.dart';
import '../../../../logic/services/image_picker/image_picker.dart';
import '../../../models/config/toolbar/buttons/image.dart';
import '../../embed_types/image.dart';
import '../utils/image_video_utils.dart';
import 'select_image_source.dart';

class QuillToolbarImageButton extends StatelessWidget {
  const QuillToolbarImageButton({
    required this.controller,
    required this.options,
    super.key,
  });

  final QuillController controller;

  final QuillToolbarImageButtonOptions options;

  double _iconSize(BuildContext context) {
    final baseFontSize = baseButtonExtraOptions(context).globalIconSize;
    final iconSize = options.iconSize;
    return iconSize ?? baseFontSize;
  }

  VoidCallback? _afterButtonPressed(BuildContext context) {
    return options.afterButtonPressed ??
        baseButtonExtraOptions(context).afterButtonPressed;
  }

  QuillIconTheme? _iconTheme(BuildContext context) {
    return options.iconTheme ?? baseButtonExtraOptions(context).iconTheme;
  }

  QuillToolbarBaseButtonOptions baseButtonExtraOptions(BuildContext context) {
    return context.requireQuillToolbarBaseButtonOptions;
  }

  IconData _iconData(BuildContext context) {
    return options.iconData ??
        baseButtonExtraOptions(context).iconData ??
        Icons.image;
  }

  String _tooltip(BuildContext context) {
    return options.tooltip ??
        baseButtonExtraOptions(context).tooltip ??
        'Insert image';
    // ('Insert Image'.i18n);
  }

  void _sharedOnPressed(BuildContext context) {
    _onPressedHandler(context);
    _afterButtonPressed(context);
  }

  @override
  Widget build(BuildContext context) {
    final tooltip = _tooltip(context);
    final iconSize = _iconSize(context);
    final iconData = _iconData(context);
    final childBuilder =
        options.childBuilder ?? baseButtonExtraOptions(context).childBuilder;

    if (childBuilder != null) {
      return childBuilder(
        QuillToolbarImageButtonOptions(
          afterButtonPressed: _afterButtonPressed(context),
          iconData: iconData,
          iconSize: iconSize,
          dialogTheme: options.dialogTheme,
          fillColor: options.fillColor,
          iconTheme: options.iconTheme,
          linkRegExp: options.linkRegExp,
          tooltip: options.tooltip,
          imageButtonConfigurations: options.imageButtonConfigurations,
        ),
        QuillToolbarImageButtonExtraOptions(
          context: context,
          controller: controller,
          onPressed: () => _sharedOnPressed(context),
        ),
      );
    }

    final theme = Theme.of(context);

    final iconTheme = _iconTheme(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor = iconTheme?.iconUnselectedFillColor ??
        (options.fillColor ?? theme.canvasColor);

    return QuillToolbarIconButton(
      icon: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      tooltip: tooltip,
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      fillColor: iconFillColor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      onPressed: () => _sharedOnPressed(context),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    final imagePickerService =
        QuillSharedExtensionsConfigurations.get(context: context)
            .imagePickerService;
    final onRequestPickImage =
        options.imageButtonConfigurations.onRequestPickImage;
    if (onRequestPickImage != null) {
      final imageUrl = await onRequestPickImage(
        context,
        imagePickerService,
      );
      if (imageUrl != null) {
        await options.imageButtonConfigurations
            .onImageInsertCallback(imageUrl, controller);
      }
      return;
    }
    final source = await showSelectImageSourceDialog(
      context: context,
    );
    if (source == null) {
      return;
    }
    final String? imageUrl;
    switch (source) {
      case InsertImageSource.gallery:
        imageUrl = (await imagePickerService.pickImage(
          source: ImageSource.gallery,
        ))
            ?.path;
        break;
      case InsertImageSource.link:
        imageUrl = await _typeLink(context);
        break;
      case InsertImageSource.camera:
        imageUrl = (await imagePickerService.pickImage(
          source: ImageSource.camera,
        ))
            ?.path;
        break;
    }
    if (imageUrl != null && imageUrl.trim().isNotEmpty) {
      await options.imageButtonConfigurations
          .onImageInsertCallback(imageUrl, controller);
    }
  }

  Future<String?> _typeLink(BuildContext context) async {
    final value = await showDialog<String>(
      context: context,
      builder: (_) => TypeLinkDialog(
        dialogTheme: options.dialogTheme,
        linkRegExp: options.linkRegExp,
      ),
    );
    return value;
  }
}
