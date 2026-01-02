extends TileMap

# --- CONFIGURATION ---
@export var target_to_follow: Node2D 
@export var generate_distance: int = 2000
@export var delete_distance: int = 2500

# --- ISLAND SETTINGS ---
@export var min_island_len: int = 4
@export var max_island_len: int = 12
@export var min_gap: int = 2
@export var max_gap: int = 6
@export var max_jump_height: int = 2

# --- TILE COORDINATES ---
const SOURCE_ID = 1
const TILE_GRASS_TOP = Vector2i(0, 0)
const TILE_DIRT_BODY = Vector2i(0, 1)

# --- GENERATION STATE ---
var current_gen_x: int = 0
var last_deleted_x: int = -100

# State Machine
enum State { ISLAND, GAP }
var current_state = State.GAP
var state_counter: int = 0
var current_height: int = 0

func _ready():
	# 1. Set Start Height to 2 (Just below the center line Y=0)
	current_height = 2 
	
	# 2. Auto-find Player
	if not target_to_follow:
		var player_node = get_tree().root.find_child("Player", true, false)
		if player_node:
			target_to_follow = player_node
		else:
			var cam = get_viewport().get_camera_2d()
			if cam:
				target_to_follow = cam

	# 3. Clear old layers
	if get_layers_count() > 1:
		clear_layer(1)
	
	# 4. GENERATE CENTER PLATFORM
	generate_safe_start_platform()
	
	# 5. Start normal generation
	check_and_update_generation()

func _process(_delta):
	if target_to_follow:
		check_and_update_generation()

# --- THE CENTER PLATFORM LOGIC ---
func generate_safe_start_platform():
	# Generate from X = -10 to X = 10 (Centered on 0)
	var start_x = -10
	var end_x = 10
	
	for x in range(start_x, end_x):
		# Place Grass at Y=2
		set_cell(0, Vector2i(x, current_height), SOURCE_ID, TILE_GRASS_TOP)
		
		# Place Dirt below it
		for d in range(1, 6):
			set_cell(0, Vector2i(x, current_height + d), SOURCE_ID, TILE_DIRT_BODY)
			
	# Tell the generator to continue starting from the right edge (x=10)
	current_gen_x = end_x

func check_and_update_generation():
	var target_tile_pos = local_to_map(to_local(target_to_follow.global_position))
	
	var view_dist_tiles = generate_distance / tile_set.tile_size.x
	var render_limit_x = target_tile_pos.x + view_dist_tiles
	var delete_limit_x = target_tile_pos.x - (delete_distance / tile_set.tile_size.x)

	while current_gen_x < render_limit_x:
		generate_single_column(current_gen_x)
		current_gen_x += 1

	if last_deleted_x < delete_limit_x:
		delete_old_columns(delete_limit_x)

func generate_single_column(x: int):
	if state_counter <= 0:
		pick_new_state()
	
	if current_state == State.ISLAND:
		set_cell(0, Vector2i(x, current_height), SOURCE_ID, TILE_GRASS_TOP)
		
		var dirt_depth = randi_range(3, 7)
		for d in range(1, dirt_depth):
			set_cell(0, Vector2i(x, current_height + d), SOURCE_ID, TILE_DIRT_BODY)
	
	state_counter -= 1

func pick_new_state():
	if current_state == State.GAP:
		current_state = State.ISLAND
		state_counter = randi_range(min_island_len, max_island_len)
		var change = randi_range(-max_jump_height, max_jump_height)
		current_height = clamp(current_height + change, -5, 15) # Allowed height range
	else:
		current_state = State.GAP
		state_counter = randi_range(min_gap, max_gap)

func delete_old_columns(limit_x: int):
	for x in range(last_deleted_x, limit_x):
		for y in range(-20, 50):
			erase_cell(0, Vector2i(x, y))
	last_deleted_x = limit_x
