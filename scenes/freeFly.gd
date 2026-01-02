extends Camera2D

# Config for movement
@export var move_speed: float = 600.0

func _ready():
	# 1. Force the camera to the start position of generation
	# Tile coordinates are (0, 10).
	# If your tiles are 16x16 pixels, the real world position is (0 * 16, 10 * 16) = (0, 160)
	# We adjust for tile size (change 16 to 32 or 64 if your tiles are bigger)
	var tile_size = 16 
	position = Vector2(0, 10 * tile_size)
	
	print("Camera moved to: ", position)

func _process(delta):
	# Standard movement code (WASD)
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += input_vector * move_speed * delta
