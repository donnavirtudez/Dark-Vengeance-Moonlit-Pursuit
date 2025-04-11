extends CharacterBody2D

const SPEED = 300.0
const RUN = 600.0
const JUMP_VELOCITY = -300.0 

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var min_x = 60

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	var is_running := Input.is_action_pressed("run")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		elif is_running:
			animated_sprite_2d.play("run")
		else: 
			animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("jump")
	
	var current_speed = RUN if is_running else SPEED
	
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	position.x = max(position.x, min_x)

	if Input.is_action_just_pressed("attack2"):
		swing_sword()
		
	move_and_slide()

func swing_sword():
	animated_sprite_2d.play("attack2")
