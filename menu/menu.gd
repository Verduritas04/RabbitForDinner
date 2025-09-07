extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_click"):
		get_tree().call_deferred("change_scene_to_file", "res://levels/level_11.tscn")
