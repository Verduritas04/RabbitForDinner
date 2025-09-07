extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.item_collected(frame)
	queue_free()
