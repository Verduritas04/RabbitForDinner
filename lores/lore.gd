extends Node2D


var canContinue : bool = false

@export var chaneScene : String = "res://levels/level_00.tscn"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_jump") and canContinue:
		get_tree().change_scene_to_file(chaneScene)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	canContinue = true
