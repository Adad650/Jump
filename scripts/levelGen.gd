extends TileMap  # <--- This matches your script

# --- CONFIGURATION ---
@export var map_width: int = 100
@export var map_height: int = 60
@export var surface_level: int = 10 

# --- TILE MAPPING ---
const SOURCE_ID = 0 
const TILE_GRASS_TOP = Vector2i(0, 0)
const TILE_DIRT_BODY = Vector2i(0, 1)

var noise = FastNoiseLite.new()

func _ready():
	noise.seed = randi()
	noise.frequency = 0.02
	generate_terrain()

func generate_terrain():
	print("--- STARTING GENERATION ---")
	clear()
	
	for x in range(map_width):
		var height_variation = noise.get_noise_1d(x) * 10
		var ground_y = int(surface_level + height_variation)
		
		# PRINT DEBUG INFO for the first tile only
		if x == 0:
			print("Placing first tile at: ", Vector2i(x, ground_y))
			print("Using Source ID: ", SOURCE_ID)
			print("Using Atlas Coords: ", TILE_GRASS_TOP)
		
		# 1. Place Grass
		set_cell(0, Vector2i(x, ground_y), SOURCE_ID, TILE_GRASS_TOP)
		
		# 2. Place Dirt
		for y in range(ground_y + 1, map_height):
			set_cell(0, Vector2i(x, y), SOURCE_ID, TILE_DIRT_BODY)
			
	print("--- GENERATION FINISHED ---")
