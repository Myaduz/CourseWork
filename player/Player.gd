extends CharacterBody2D

class_name Player

@export var speed = 200.0
@export var jump_velocity = -350.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var ap: AnimationPlayer = $AnimationPlayer

var is_crouching: bool = false
var need_stand: bool = false
@export var crouch_speed_multiplier: float = 0.5
@onready var crouch_can_stand_shapecast: ShapeCast2D = $ShapeCast2D

var direction: int = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var cshape: CollisionShape2D = $CollisionShape2D
var stand_cshape = preload("res://player/player_stand_collision.tres")
var crouch_cshape = preload("res://player/player_crouch_collision.tres")


@onready var platform: CollisionShape2D = $StaticBody2D/CollisionShape2D
var stand_platform_cshape = preload("res://player/stand_platform_collision.tres")
var crouch_platform_cshape = preload("res://player/crouch_platform_collision.tres")
var is_processed: bool = true

func toggle_process():
	is_processed = not is_processed
	if not is_processed:
		is_crouching = false
		direction = 0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_processed:
		if is_jump_press() and is_on_floor():
			stand()
			velocity.y = jump_velocity

		direction = get_move_direction()
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if is_crouch_press() and is_on_floor():
			crouch()
	
		if is_crouch_release() and can_stand:
			need_stand = true
	
	if need_stand and can_stand():
		stand()
		need_stand = false
	
	move_and_slide()
	apply_animations()


var ray_origin = position + Vector2(0, -14) # верх перса
var ray_direction = Vector2(0, -1) # вектор вверх
var ray_length = 28 - 15 # разница верхов stand - crouch

func can_stand():
	return not crouch_can_stand_shapecast.get_collision_count() > 0
	

func is_jump_press():
	return Input.is_action_just_pressed("jump")


func get_move_direction():
	return Input.get_axis("left", "right")


func is_crouch_press():
	return Input.is_action_just_pressed("crouch")


func is_crouch_release():
	return  Input.is_action_just_released("crouch")


func apply_animations():
	if is_on_floor():
		if is_crouching:
			if direction != 0:
				ap.play("crouch_walk")
				sprite.flip_h = (direction == -1)
			else:
				ap.play("crouch_idle")
		else:
			if direction != 0:
				ap.play("run")
				sprite.flip_h = (direction == -1)
			else:
				ap.play("idle")
	else:
		if velocity.y < -50:
			ap.play("jump_up")
		elif velocity.y > 50:
			ap.play("jump_down")
		else:
			ap.play("mid_air")
		sprite.flip_h = (direction == -1)


func crouch():
	if is_crouching:
		return
	cshape.shape = crouch_cshape
	cshape.position.y = 8.5
	
	platform.shape = crouch_platform_cshape
	platform.position.y = 12
	
	is_crouching = true
	speed *= crouch_speed_multiplier


func stand():
	if not is_crouching:
		return
	cshape.shape = stand_cshape
	cshape.position.y = 2
	
	platform.shape = stand_platform_cshape
	platform.position.y = 0

	is_crouching = false
	speed /= crouch_speed_multiplier


