extends Player

class_name Clone

@export var color: Color = Color.SKY_BLUE

var input_history: Array[CustomInput] = []
var is_jump: bool = false
var is_crouch: CustomInput.InputValue = CustomInput.InputValue.NONE
var left: bool = false
var right: bool = false
var start_time: float = 0.0

func _ready():
	(sprite.material as ShaderMaterial).set_shader_parameter("color_override", color)
	speed = 200
	start_time = Time.get_ticks_usec()


func _process(_delta):
	replay_inputs()

func replay_inputs() -> void:
	for input in input_history:
		if Time.get_ticks_usec() >= start_time + input.timestamp:
			apply_input(input)
			input_history.erase(input)
	if input_history.is_empty():
		cancel_move()

func cancel_move():
	left = false
	right = false
	is_jump = false


func apply_input(input: CustomInput) -> void:
	match input.type:
		CustomInput.InputType.LEFT:
			if input.is_pressed():
				left = true
			elif input.is_released():
				left = false
		CustomInput.InputType.RIGHT:
			if input.is_pressed():
				right = true
			elif input.is_released():
				right = false
			right = input.is_pressed()
		CustomInput.InputType.JUMP:
			if input.is_pressed():
				is_jump = true
			elif input.is_released():
				is_jump = false
			is_jump = input.is_pressed()
		CustomInput.InputType.CROUCH:
			is_crouch = input.value
		CustomInput.InputType.INTERACT:
			if input.is_pressed():
				left = true
			elif input.is_released():
				left = false
			pass


func is_jump_press():
	return is_jump


func get_move_direction():
	if left and !right:
		return -1
	elif right and !left:
		return 1
	else:
		return 0

func is_crouch_press():
	return is_crouch == CustomInput.InputValue.PRESSED


func is_crouch_release():
	return is_crouch == CustomInput.InputValue.RELEASE
