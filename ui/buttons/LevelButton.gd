extends ButtonUI


@export_file var level_path

@onready var level_manager: LevelManager = get_node("/root/LevelManagerGlobal")

func _on_pressed() -> void:
	if level_path == null:
		return
	level_manager.level_path = level_path
	get_tree().change_scene_to_file("res://game.tscn")
