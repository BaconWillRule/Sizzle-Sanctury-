
extends CharacterBody2D

@export var speed: float = 220.0

func _physics_process(_delta: float) -> void:
	# WASD actions (defined in project.godot); arrow keys via ui_* as fallback
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir == Vector2.ZERO:
		dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if dir != Vector2.ZERO:
		dir = dir.normalized()
	velocity = dir * speed
	move_and_slide()
