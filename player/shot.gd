extends Node2D


const SPEED : float = 160

var xDir : int = 1

@onready var ray := $Node/RayCast2D


func _process(delta: float) -> void:
	var prevPos = position
	position.x += xDir * SPEED * delta
	ray.position = prevPos - Vector2(xDir, 0) * 8
	ray.target_position = position - prevPos
	ray.force_raycast_update()
	if ray.is_colliding():
		var coll = ray.get_collider()
		if coll.has_method("get_hurt"):
			coll.get_hurt()
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
