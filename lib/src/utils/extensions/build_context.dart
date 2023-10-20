import 'package:flutter/widgets.dart' show BuildContext;

import '../../../flutter_quill.dart';

extension BuildContextExt on BuildContext {
  QuillProvider get requireQuillProvider {
    return QuillProvider.ofNotNull(this);
  }

  QuillProvider? get quillProvider {
    return QuillProvider.of(this);
  }

  QuillController? get quilController {
    return quillProvider?.configurations.controller;
  }

  QuillController get requireQuillController {
    return requireQuillProvider.configurations.controller;
  }

  QuillConfigurations get requireQuillConfigurations {
    return requireQuillProvider.configurations;
  }

  QuillConfigurations? get quillConfigurations {
    return quillProvider?.configurations;
  }

  QuillSharedConfigurations? get sharedQuillConfigurations {
    return quillConfigurations?.sharedConfigurations;
  }

  QuillSharedConfigurations get requireSharedQuillConfigurations {
    return requireQuillConfigurations.sharedConfigurations;
  }
}
