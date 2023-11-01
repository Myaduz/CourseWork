extends Node2D

signal hard_reset_clones
signal new_clone(create_clone_func: Callable)
signal overwrite_clone

var clone_scene = preload("res://clone/clone.tscn")

@onready var clone_count_label: Label = $CanvasLayer/ThemeWrapper/UI/CloneCountLabel

var init_clone_count: int = 1337
var clone_count: int = 1337:
	set(value):
		clone_count_label.text = "Clones: " + str(value)
		clone_count = value
	get:
		return clone_count

@onready var player: Player = $Player

@onready var level_manager: LevelManager = get_node("/root/LevelManagerGlobal")
@onready var clone_manager: CloneManager = get_node("/root/CloneManagerGlobal")
@onready var pause_menu: PauseMenu = $CanvasLayer/ThemeWrapper/PauseMenu

var pause_menu_opened: bool = false

var spawn_point: Vector2 = Vector2.ZERO

var clones = []


func _ready():
	randomize()

	var level_path = level_manager.level_path
	var level_scene = ResourceLoader.load(level_path)
	var level = level_scene.instantiate()
	add_child(level)

	spawn_point = level_manager.get_spawn_point()
	clone_count = level.clone_count
	init_clone_count = clone_count
	set_game()
	clone_manager.overwrite_clone()


func set_game():
	kill_clones()
	player.position = spawn_point
	create_clones()


func kill_clones():
	for clone in clones:
		clone.queue_free()
	clones = []

var clone_colors = [
	"5fcde4",
	"df7126",
	"951799",
	"af1ab2",
	"6abe30",
	"99e550",
	"b35b20",
	"ce5050",
	"ac3232",
	"fbf236"
]


func create_clones():
	for i in clone_manager.saved_histories.size():
		var history = clone_manager.saved_histories[i]
		var color = clone_colors[i]
		var clone = create_clone(history, color)
		clones.append(clone)


func _process(_delta):
	if Input.is_action_just_pressed("next_clone"):
		# if clone count not bigger max clones
		if clone_count > 0:
			clone_manager.new_clone()
			set_game()
			clone_count -= 1
		else:
			pass # можно анимировать недоступность добавления клона


	if Input.is_action_just_pressed("rewrite_current_clone"):
		clone_manager.overwrite_clone()
		set_game()
	
	if Input.is_action_just_pressed("toggle_pause_menu"):
		pause_menu_toggle()


func pause_menu_toggle():
		if pause_menu_opened:
			pause_menu.close()
		else:
			pause_menu.open()
		pause_menu_opened = not pause_menu_opened
		player.toggle_process()


func create_clone(history: Array[CustomInput], clone_color = Color.YELLOW):
	var clone: Clone = clone_scene.instantiate()
	clone.color = clone_color
	clone.input_history = history.duplicate()
	add_child(clone)
	clone.position = spawn_point
	return clone


func close_game():
	get_tree().quit()


func _on_resume_pressed():
	pause_menu_toggle()


func _on_restart_pressed():
	clone_manager.hard_reset_clones()
	clone_count = init_clone_count
	set_game()
	pause_menu_toggle()



func _on_to_menu_pressed():
	clone_manager.hard_reset_clones()
