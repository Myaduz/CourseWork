extends Interactable

class_name FloorButton

@onready var ap: AnimationPlayer = $AnimationPlayer
@export var interactable_path: NodePath

var activated: bool = false

func interact():
	activate(true)


func reset():
	activate(false)


func activate(value: bool):
	activated = value
	if activated == true:
		ap.play("activated")
		(get_node(interactable_path) as Switch).on()
	else:
		(get_node(interactable_path) as Switch).off()
		ap.play("idle")


var body_count = 0

func _on_body_entered(body: Node2D):
	if body is Player or body is Clone:
		body_count += 1
		if body_count == 1:
			activate(true)
		


func _on_body_exited(body):
	if body is Player or body is Clone:
		body_count -= 1
		if body_count == 0:
			activate(false)
