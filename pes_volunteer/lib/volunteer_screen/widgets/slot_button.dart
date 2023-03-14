import 'package:flutter/material.dart';

class SlotButton extends InkWell {
  SlotButton({onPressed, text, isActive = true})
      : super(
            onTap: isActive == null
                ? onPressed
                : isActive
                    ? onPressed
                    : () {},
            child: Container(
              width: 116,
              height: 29,
              decoration: BoxDecoration(
                color: isActive == null
                    ? const Color(0xff274D76)
                    : isActive
                        ? const Color(0xff274D76)
                        : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xff274d76),
                  width: 1,
                ),
              ),
              child: Center(
                  child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              )),
            ));
}
