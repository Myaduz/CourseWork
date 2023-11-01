extends Node2D

class_name Level

@export var clone_count = 1
@onready var spawn_point: Marker2D = $SpawnPoint

func get_spawn_point() -> Vector2:
	return spawn_point.position
