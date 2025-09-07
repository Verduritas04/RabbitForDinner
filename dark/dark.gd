extends Node2D


const divVal : float = 20.0

var light : float = 1.0


func _ready() -> void:
	var player = get_tree().current_scene.get_node("Player")
	player.connect("send_pos", update_dark)
	player.connect("gun_shot", set_light)

func update_dark(pos : Vector2) -> void:
	pos += Vector2.UP * 16
	for sprite in get_children():
		sprite.frame = clamp(pos.distance_to(sprite.global_position) / divVal - light, 0, 4)

func _process(delta: float) -> void:
	light = move_toward(light, 1.0, 10 * delta)

func set_light() -> void:
	light = 3.0
