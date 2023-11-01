extends ButtonUI


@export_file var level_path

@onready var level_manager: LevelManager = get_node("/root/LevelManagerGlobal")

func _on_pressed() -> void:
	if level_path == null:
		return
	print(level_path)
	if level_path.ends_with(".remap"):
		var formatted_name = level_path.trim_suffix('.remap')
		level_manager.level_path = formatted_name
	else:
		level_manager.level_path = level_path
	get_tree().change_scene_to_file("res://game.tscn")
