import 'package:flutter/material.dart';

//import package
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import bloc

class DropdownTextField extends StatefulWidget {
  Function(String) onSelect;
  String placeHolder = "";
  DropdownTextField({
    super.key,
    this.placeHolder = "",
    required this.options,
    required this.onSelect,
  });

  final List<String> options;
  @override
  _DropdownTextFieldState createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  final TextEditingController _typeAheadController = TextEditingController();
  TextEditingController _ipAddressController = TextEditingController();

  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _typeAheadController,
        decoration: InputDecoration(
          labelText: widget.placeHolder,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
      suggestionsCallback: (pattern) {
        return widget.options.where(
            (option) => option.toLowerCase().contains(pattern.toLowerCase()));
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        _typeAheadController.text = suggestion;
        setState(() {
          _selectedValue = suggestion;
        });
        if (_selectedValue != null) widget.onSelect(_selectedValue!);
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please select an option';
        }
        return null;
      },
    );
  }
}
