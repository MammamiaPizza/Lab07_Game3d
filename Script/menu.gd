extends Control

@export var playscene : PackedScene = load("res://Scene/play_scene.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(playscene)


func _on_button_2_pressed() -> void:
	get_tree().quit()

func cleargame():
	$CanvasLayer/Label2.show()
