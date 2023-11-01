extends Control

class_name PauseMenu

func _ready():
	close()

func open():
	visible = true
	set_process_input(true)

func close():
	visible = false
	set_process_input(false)
