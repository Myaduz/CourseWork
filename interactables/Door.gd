extends Switch

class_name Door

@onready var ap: AnimationPlayer = $AnimationPlayer

var opened: bool = false


func on():
	opened = true
	ap.play("activation")


func off():
	opened = false
	ap.play("deactivation")


func reset():
	ap.play("idle")
	opened = false
