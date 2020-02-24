extends TileMap
class_name Map




signal Generation_Finished(map)
signal Generation_Update(percentage, message)


var thread : Thread = null
var _steps : int = 0
var _change_dir_chance : float = 0.0
var _rng : RandomNumberGenerator
var _tree = null




func startGeneration(tree, var steps_range := Vector2(500, 1000), var change_dir_chance : float = 0.2) -> void:
	_tree = tree
	
	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	
	_change_dir_chance = change_dir_chance
	_steps = _rng.randf_range(steps_range.x, steps_range.y)
	
	thread = Thread.new()
	thread.start(self, "pGenerateMap", _rng.seed)




func pGenerateMap(userdata):
	var safeguard : int = 0
	
	var cur_x : int = 0
	var cur_y : int = 0
	var directions : Array = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
	var diagonals : Array = [Vector2(-1, -1), Vector2(-1, 1), Vector2(1, -1), Vector2(1, 1)]
	
	emit_signal("Generation_Update", 0, "Processing Steps [" + str(0) + "/" + str(_steps) +"]")
	
	for step in range(_steps):
		if _rng.randf() < _change_dir_chance:
			directions.shuffle()
		var dir : Vector2 = directions[0]
		
		cur_x += dir.x as int
		cur_y += dir.y as int
		
		set_cell(cur_x, cur_y, 1)
		
		for d in directions:
			var x : int = cur_x + d.x
			var y : int = cur_y + d.y
			if get_cell(x, y) != 1:
				set_cell(x, y, 0)
		
		for d in diagonals:
			var x : int = cur_x + d.x
			var y : int = cur_y + d.y
			
			if get_cell(x, y) != 1:
				set_cell(x, y, 0)
		
		safeguard += 1
		if safeguard > 1000:
			safeguard = 0
			yield(_tree, "idle_frame")
			emit_signal("Generation_Update", (step as float / _steps as float) * 1.0, "Processing Steps [" + str(step) + "/" + str(_steps) +"]")
	
	
#	var count : int = 0
#	var used_rect : Rect2 = get_used_rect()
#	var bottom_right : Vector2 = used_rect.end
#	var top_left : Vector2 = used_rect.position
#	var total : int = (bottom_right.x - top_left.x) * (bottom_right.y - top_left.y)
#
#	emit_signal("Generation_Update", 0.5, "Fill in Map [" + str(0) + "/" + str(total) +"]")
#
#	for y in range(top_left.y, bottom_right.y + 1):
#		for x in range(top_left.x, bottom_right.x + 1):
##			if x == top_left.x or x == bottom_right.x or y == top_left.y or y == bottom_right.y:
##				set_cell(x, y, 0)
##			else:
##				if get_cell(x, y) == -1:
##					set_cell(x, y, 0)
#			if get_cell(x, y) == -1:
#				var wall_count : int = 0
#				if get_cell(x + 1, y) == 0:
#					wall_count += 1
#				if get_cell(x - 1, y) == 0:
#					wall_count += 1
#				if get_cell(x, y + 1) == 0:
#					wall_count += 1
#				if get_cell(x, y - 1) == 0:
#					wall_count += 1
#
#				if wall_count >= 2:
#					set_cell(x, y, -2)
#
#			count += 1
#			safeguard += 1
#			if safeguard > 1000:
#				safeguard = 0
#				yield(_tree, "idle_frame")
#				emit_signal("Generation_Update", 0.5 + (count as float / total as float) * 0.25, "Fill in Walls [" + str(count) + "/" + str(total) +"]")
#
#	count = 0
#	for y in range(top_left.y, bottom_right.y + 1):
#		for x in range(top_left.x, bottom_right.x + 1):
#			if get_cell(x, y) == -2:
#				set_cell(x, y, 0)
#
#			count += 1
#			safeguard += 1
#			if safeguard > 1000:
#				safeguard = 0
#				yield(_tree, "idle_frame")
#				emit_signal("Generation_Update", 0.75 + (count as float / total as float) * 0.25, "Fill in Corners [" + str(count) + "/" + str(total) +"]")
	
	
	emit_signal("Generation_Finished", self)
	thread.wait_to_finish()
