extends RefCounted
class_name DrunkardGen

# Simple random walk ("drunkard") digger.
# grid_size: Vector2i(w,h)
# target_floor_count: number of floor tiles to carve
# seed: 0 => randomize
func generate(grid_size: Vector2i, target_floor_count: int, max_steps: int = 100000, seed: int = 0) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	if seed == 0:
		rng.randomize()
	else:
		rng.seed = seed

	var floors := {}
	var pos := Vector2i(grid_size.x / 2, grid_size.y / 2)
	floors[pos] = true

	var steps := 0
	while floors.size() < target_floor_count and steps < max_steps:
		var dir := rng.randi_range(0, 3)
		match dir:
			0: pos.x += 1
			1: pos.x -= 1
			2: pos.y += 1
			3: pos.y -= 1
		# keep inside a 1-tile border
		pos.x = clampi(pos.x, 1, grid_size.x - 2)
		pos.y = clampi(pos.y, 1, grid_size.y - 2)
		floors[pos] = true
		steps += 1
	return floors
