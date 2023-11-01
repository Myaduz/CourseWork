extends Node

class_name CustomInput

enum InputType {
	NONE,
	LEFT,
	RIGHT,
	JUMP,
	CROUCH,
	INTERACT
}

enum InputValue {
	NONE,
	PRESSED,
	RELEASE,
}

var type: InputType = InputType.NONE
var value: InputValue = InputValue.NONE
var timestamp: float = 0.0

func is_pressed():
	return value == InputValue.PRESSED

func is_released():
	return value == InputValue.RELEASE


static func get_type_name(type: InputType) -> String:
	return InputType.keys()[type]

static func get_value_name(value: InputValue) -> String:
	return InputValue.keys()[value]
	
