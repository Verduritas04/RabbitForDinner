extends Camera2D


func _ready() -> void:
	var player = get_tree().current_scene.get_node("Player")
	player.connect("send_pos", update_pos)

func update_pos(pos : Vector2) -> void:
	# The game resolution is 320 * 270
	var posX = int(pos.x / 320) * 320
	var posY = int(pos.y / 270) * 270
	position = Vector2(posX + 160, posY + 135)
