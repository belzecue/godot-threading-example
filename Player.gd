extends Sprite



var move : Vector2 = Vector2(0, 0)
#var half_size : float = 0.0


#func _ready() -> void:
#	half_size = texture.get_width() * scale.x * 0.5




func _process(delta: float) -> void:
	global_position += move.normalized() * delta * 450
	
#	if global_position.x > 1024:
#		global_position.x = half_size
#	elif global_position.x < 0:
#		global_position.x = 1024 - half_size
#
#	if global_position.y > 600:
#		global_position.y = half_size
#	elif global_position.y < 0:
#		global_position.y = 600 - half_size


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		$Camera2D.zoom = Vector2(1, 1)

	if event.is_action_pressed("ui_up"):
		$Camera2D.zoom += Vector2(0.5, 0.5)
	
	if event.is_action_pressed("MoveLeft"):
		move.x = -1
	
	if event.is_action_released("MoveLeft") and move.x == -1:
		move.x = 0
	
	if event.is_action_pressed("MoveRight"):
		move.x = 1
	
	if event.is_action_released("MoveRight") and move.x == 1:
		move.x = 0
	
	if event.is_action_pressed("MoveUp"):
		move.y = -1
	
	if event.is_action_released("MoveUp") and move.y == -1:
		move.y = 0
	
	if event.is_action_pressed("MoveDown"):
		move.y = 1
	
	if event.is_action_released("MoveDown") and move.y == 1:
		move.y = 0


func _exit_tree() -> void:
	move = Vector2.ZERO
