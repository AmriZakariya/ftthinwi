import 'package:flutter_form_bloc/flutter_form_bloc.dart';
class CustomBooleanFieldBloc<ExtraData> extends BooleanFieldBloc<ExtraData> {
  final Object Function(bool value)? _toJson;

  CustomBooleanFieldBloc({
    String? name,
    bool initialValue = false,
    List<Validator<bool>>? validators,
    List<AsyncValidator<bool>>? asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<bool>? suggestions,
    ExtraData? extraData,
    Object Function(bool value)? toJson,
  })  : _toJson = toJson,
        super(
        name: name,
        initialValue: initialValue,
        validators: validators,
        asyncValidators: asyncValidators,
        asyncValidatorDebounceTime: asyncValidatorDebounceTime,
        suggestions: suggestions,
        extraData: extraData,
      );

  @override
  Object toJson(bool value) {
    if (_toJson != null) {
      return _toJson!(value);
    }
    // Default implementation: return "oui" for true and "non" for false
    return value ? "oui" : "non";
  }
}
