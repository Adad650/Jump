extends CharacterBody2D

var SPEED = 150.0
const SPRINT_SPEED = 200.0  # Add this for sprint
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("Oui")

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	# Calculate current speed (sprint overrides normal)
	var current_speed = SPRINT_SPEED 
	if Input.is_action_pressed("roll"):
		current_speed = SPRINT_SPEED
		# print("yYes")
		get_node("Timer").start()
		
	else: 
		current_speed = SPEED
	
	# Flips the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		elif Input.is_action_pressed("sprint"):
			animated_sprite.play("sprint")  # Add "sprint" animation to your sprite
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Actually moves it
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
