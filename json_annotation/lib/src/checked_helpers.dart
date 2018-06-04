// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'allowed_keys_helpers.dart';

/// Helper function used in generated code when
/// `JsonSerializableGenerator.checked` is `true`.
///
/// Should not be used directly.
T $checkedNew<T>(String className, Map map, T constructor(),
    {Map<String, String> fieldKeyMap}) {
  fieldKeyMap ??= const {};

  try {
    return constructor();
  } on CheckedFromJsonException catch (e) {
    if (identical(e.map, map) && e._className == null) {
      e._className = className;
    }
    rethrow;
  } catch (error, stack) {
    String key;
    if (error is ArgumentError) {
      key = fieldKeyMap[error.name] ?? error.name;
    } else if (error is MissingRequiredKeysException) {
      key = error.missingKeys.first;
    }
    throw new CheckedFromJsonException._(error, stack, map, key,
        className: className);
  }
}

/// Helper function used in generated code when
/// `JsonSerializableGenerator.checked` is `true`.
///
/// Should not be used directly.
T $checkedConvert<T>(Map map, String key, T castFunc(Object value)) {
  try {
    return castFunc(map[key]);
  } on CheckedFromJsonException {
    rethrow;
  } catch (error, stack) {
    throw new CheckedFromJsonException._(error, stack, map, key);
  }
}

/// Exception thrown if there is a runtime exception in `fromJson`
/// code generated when `JsonSerializableGenerator.checked` is `true`
class CheckedFromJsonException implements Exception {
  /// The [Error] or [Exception] that triggered this exception.
  ///
  /// If this instance was created by user code, this field will be `null`.
  final Object innerError;

  /// The [StackTrace] for the [Error] or [Exception] that triggered this
  /// exception.
  ///
  /// If this instance was created by user code, this field will be `null`.
  final StackTrace innerStack;

  /// The key from [map] that corresponds to the thrown [innerError].
  ///
  /// May be `null`.
  final String key;

  /// The source [Map] that was used for decoding when the [innerError] was
  /// thrown.
  final Map map;

  /// A human-readable message corresponding to [innerError].
  ///
  /// May be `null`.
  final String message;

  /// The name of the class being created when [innerError] was thrown.
  String get className => _className;
  String _className;

  /// Creates a new instance of [CheckedFromJsonException].
  CheckedFromJsonException(this.map, this.key, String className, this.message)
      : _className = className,
        innerError = null,
        innerStack = null;

  CheckedFromJsonException._(
      this.innerError, this.innerStack, this.map, this.key,
      {String className})
      : _className = className,
        message = _getMessage(innerError);

  static String _getMessage(Object error) {
    if (error is ArgumentError) {
      return error.message?.toString();
    } else if (error is UnrecognizedKeysException) {
      return error.message;
    } else if (error is MissingRequiredKeysException) {
      return error.message;
    }
    return null;
  }
}
