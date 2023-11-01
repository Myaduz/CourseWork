extends Node2D

class_name CloneManager

#@export var max_clone_count: int = 2
const CustomInput = preload("res://shared/CustomInput.gd")
#var clone_count: int = max_clone_count

var saved_histories: Array[Array] = []
var current_history: Array[CustomInput] = []
var record_start_time: float = Time.get_ticks_usec()


func history_start():
	return current_history[0]


func history_end():
	return current_history[current_history.size()-1]


func _input(event):
	if event is InputEventKey:
		var time = Time.get_ticks_usec()
		var input_type: CustomInput.InputType = CustomInput.InputType.NONE
		var input_value: CustomInput.InputValue = CustomInput.InputValue.NONE
		match event.keycode:
			KEY_A:
				input_type = CustomInput.InputType.LEFT
			KEY_D:
				input_type = CustomInput.InputType.RIGHT
			KEY_SPACE:
				input_type = CustomInput.InputType.JUMP
			KEY_CTRL:
				input_type = CustomInput.InputType.CROUCH
			KEY_E:
				input_type = CustomInput.InputType.INTERACT
			_:
				input_type = CustomInput.InputType.NONE
		
		if event.pressed:
			input_value = CustomInput.InputValue.PRESSED
		else:
			input_value = CustomInput.InputValue.RELEASE
		
		if input_type != CustomInput.InputType.NONE:
			record_input(input_type, input_value, time)


func start_record():
	current_history = []
	record_start_time = Time.get_ticks_usec()


func record_input(input_type: CustomInput.InputType,
	input_value: CustomInput.InputValue, timestamp: float) -> void:
	var input = CustomInput.new()
	input.type = input_type
	input.value = input_value
	input.timestamp = timestamp - record_start_time
	current_history.append(input)


func end_record():
	saved_histories.append(current_history)


func hard_reset_clones():
	saved_histories = []
	start_record()


func new_clone():
	end_record()
	start_record()


func overwrite_clone():
	start_record()

