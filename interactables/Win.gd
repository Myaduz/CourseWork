extends Area2D

@onready var clone_manger: CloneManager = $"/root/CloneManagerGlobal"

func _on_body_entered(body):
	if body is Player:
		win()


func win():
	clone_manger.hard_reset_clones()
	get_tree().change_scene_to_file("res://scenes/LevelSelectScreen.tscn")
