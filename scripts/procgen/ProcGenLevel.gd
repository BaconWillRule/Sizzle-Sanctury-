extends Node2D

@onready var tilemap: TileMap = $TileMap

@export var grid_size := Vector2i(64, 48)
@export var floor_ratio := 0.30
@export var tile_set_path := "res://tiles/tileset.tres"
@export var floor_tile_id := 0
@export var wall_tile_id := 1
@export var reroll_key := KEY_R
@export var seed := 0

var floors := {}
var walls := {}

func _ready() -> void:
	# try to auto-assign tileset if present
	if tilemap.tile_set == null and ResourceLoader.exists(tile_set_path):
		tilemap.tile_set = load(tile_set_path)
	generate_and_build()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == reroll_key:
		generate_and_build()

func generate_and_build() -> void:
	_clear_spawns()
	_generate()
	_paint_tilemap()
	_place_spawns()

func _generate() -> void:
	var target_count := int(grid_size.x * grid_size.y * floor_ratio)
	var gen := DrunkardGen.new()
	floors = gen.generate(grid_size, target_count, 200000, seed)
	walls.clear()
	for cell in floors.keys():
		for n in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]:
			var nb := cell + n
			if nb.x < 0 or nb.y < 0 or nb.x >= grid_size.x or nb.y >= grid_size.y:
				continue
			if not floors.has(nb):
				walls[nb] = true

func _paint_tilemap() -> void:
	tilemap.clear()
	# paint floors
	for cell in floors.keys():
		# set_cell(layer, cell, source_id, atlas) usage – we set tiles using the tile id index
		tilemap.set_cellv(cell, floor_tile_id)
	# paint walls
	for cell in walls.keys():
		tilemap.set_cellv(cell, wall_tile_id)

func _place_spawns() -> void:
	var tile_size := tilemap.cell_size
	var start := Vector2i(grid_size.x/2, grid_size.y/2)
	if not floors.has(start):
		# fallback to any floor
		for k in floors.keys():
			start = k
			break

	var far := _farthest_floor_from(start)
	# Player spawn
	var p := Node2D.new()
	p.name = "PlayerSpawn"
	add_child(p)
	p.position = tilemap.map_to_local(start) + tile_size/2
	# Exit spawn
	var e := Node2D.new()
	e.name = "ExitDoorSpawn"
	add_child(e)
	e.position = tilemap.map_to_local(far) + tile_size/2

func _farthest_floor_from(from: Vector2i) -> Vector2i:
	var q := []
	var dist := {}
	q.push_back(from)
	dist[from] = 0
	var last := from
	while q.size() > 0:
		var c := q.pop_front()
		last = c
		for n in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]:
			var nb := c + n
			if not floors.has(nb): continue
			if dist.has(nb): continue
			dist[nb] = dist[c] + 1
			q.push_back(nb)
	return last

func _clear_spawns() -> void:
	var old := get_node_or_null("PlayerSpawn")
	if old: old.queue_free()
	old = get_node_or_null("ExitDoorSpawn")
	if old: old.queue_free()
