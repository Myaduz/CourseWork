extends Node2D

class_name LevelManager

var level_path: String = ""

func get_spawn_point() -> Vector2:
	var level: Level = get_tree().get_first_node_in_group("Level")
	return level.get_spawn_point()
