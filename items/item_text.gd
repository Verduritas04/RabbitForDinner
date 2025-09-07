extends Label


func _process(delta: float) -> void:
	position.y -= 20 * delta

func _on_timer_timeout() -> void:
	queue_free()
