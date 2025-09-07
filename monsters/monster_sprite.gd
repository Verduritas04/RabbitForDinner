extends Sprite2D


var dir : Vector2 = Vector2.RIGHT.rotated(randf_range(0, 2 * PI))


func _process(delta: float) -> void:
	frame = randi() % 4
	position += dir * 7 * delta
	visible = !visible

func _on_timer_timeout() -> void:
	queue_free()
