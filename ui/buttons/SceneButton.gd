extends ButtonUI


@export_file var scene_path

func _on_pressed() -> void:
	if scene_path == null:
		return
	get_tree().change_scene_to_file(scene_path)

