import 'package:chatex/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../size.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.onChanged,
    required this.hintText,
    required this.isNum,
    required this.isCountryCode,
  }) : super(key: key);
  final bool isNum, isCountryCode;
  final String hintText;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    Pallete pallete = Pallete(context);
    String reg = r'[0-9]';

    TextEditingController controller = TextEditingController();
    return Container(
      decoration: BoxDecoration(
          color: pallete.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getHeight(10)),
        child: TextFormField(
          maxLength: isNum ? 10 : null,
          controller: controller,
          readOnly: isCountryCode,
          style: TextStyle(color: pallete.primaryDark),
          onChanged: (value) {
            onChanged(value);
            if (isNum && value.length > 5) {
              controller.text =
                  "${value.substring(0, 5)} ${value.substring(5)}";
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          },
          validator: (value) =>
              int.tryParse(value!) == null ? "Invalid int" : null,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          inputFormatters: [
            // for below version 2 use this
            if (isNum) FilteringTextInputFormatter.allow(RegExp(reg)),
          ],
          cursorRadius: const Radius.circular(8),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            counterText: "",
            hintStyle: TextStyle(
                color: isCountryCode
                    ? pallete.primaryDark
                    : pallete.primaryLight.withOpacity(0.7),
                fontSize: getHeight(16)),
          ),
        ),
      ),
    );
  }
}
