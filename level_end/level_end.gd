extends Area2D


@export var chaneScene : String = "res://levels/level_00.tscn"


func _on_body_entered(body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file", chaneScene)
