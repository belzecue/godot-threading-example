extends Node2D
#makes instance of map -> tells map to generate via threading
#map has signal for generation finished
#level puts map inside the tree



var generating_map : Map = null
var finished_maps : Array = []
var cur_map_index : int = 0

onready var map := preload("res://Map.tscn")
onready var progress_bar := $CanvasLayer/ColorRect/ProgressBar
onready var label := $CanvasLayer/ColorRect/Label



func _ready() -> void:
	progress_bar.value = 0.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		pInstantiateMap()
	
	if event.is_action_pressed("ui_left"):
		pDecreaseIndex()
	elif event.is_action_pressed("ui_right"):
		pIncreaseIndex()



func On_Map_Generation_Finished(map) -> void:
	pRemoveCurMap()
	label.text = "Generation Finished"
	progress_bar.value = 100
	finished_maps.append(generating_map)
	cur_map_index = finished_maps.size() - 1
	pAddMap()
	#add_child(generating_map)
	generating_map = null


func On_Map_Generation_Update(var percentage : float, message : String) -> void:
	progress_bar.value = percentage * 100
	label.text = message




func pDecreaseIndex() -> void:
	if finished_maps.size() <= 0: return
	
	pRemoveCurMap()
	if cur_map_index > 0:
			cur_map_index -= 1
	else:
		cur_map_index = finished_maps.size() - 1
	pAddMap()


func pIncreaseIndex() -> void:
	if finished_maps.size() <= 0: return
	
	pRemoveCurMap()
	if cur_map_index < finished_maps.size() - 1:
		cur_map_index += 1
	else:
		cur_map_index = 0
	pAddMap()


func pRemoveCurMap() -> void:
	if finished_maps.size() > 0:
		remove_child(finished_maps[cur_map_index])


func pAddMap() -> void:
	add_child(finished_maps[cur_map_index])


func pInstantiateMap() -> void:
	if generating_map != null: return
	
	progress_bar.value = 0.0
	
	var m = map.instance()
	generating_map = m
	
	m.connect("Generation_Finished", self, "On_Map_Generation_Finished")
	m.connect("Generation_Update", self, "On_Map_Generation_Update")
	
	#m.startGeneration(get_tree(), Vector2(5000, 20000), 0.5)
	m.startGeneration(get_tree(), Vector2(10000, 50000), 0.95)
	#m.startGeneration(get_tree(), Vector2(100000, 500000), 0.66)
	#m.startGeneration(get_tree(), Vector2(100000, 500000), 0.15)
