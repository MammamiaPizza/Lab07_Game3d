extends Node3D

var score

@onready var gomenu = preload("res://Scene/Menu/MenuScene.tscn")

@onready var player = $Player


func _process(delta: float) -> void:
	score = player.itemcount
	$Control/CanvasLayer/Label.text = "Page: " + str(score) + "/5"


func death():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	call_deferred("_go_to_menu")
	
func _go_to_menu():
	get_tree().change_scene_to_packed(gomenu)


func _on_player_escape() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	call_deferred("_go_to_menu")
