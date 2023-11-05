# Flutter Quill Test

## Testing
To aid in testing applications using the editor an extension to the flutter `WidgetTester` is provided which includes methods to simplify interacting with the editor in test cases.

Import the test utilities in your test file:

```dart
import 'package:flutter_quill/flutter_quill_test.dart';
```

and then enter text using `quillEnterText`:

```dart
await tester.quillEnterText(find.byType(QuillEditor), 'test\n');
```

## Contributing

We welcome contributions!

Please follow these guidelines when contributing to our project. See [CONTRIBUTING.md](./../CONTRIBUTING.md) for more details.

## License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.