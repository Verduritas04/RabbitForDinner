extends CharacterBody2D


const Sprite := preload("res://monsters/monster_sprite.tscn")

var player = null
var victim = null

@export var radious : float = 8
@export var spd     : float = 50
@export var health : int = 4

@onready var audio := $AudioStreamPlayer2D
@onready var anim  := $AnimationPlayer


func _process(delta: float) -> void:
	if player == null:
		return
	var dir = position.direction_to(player.position + Vector2(0, -16))
	velocity = spd * dir
	move_and_slide()
	if victim != null:
		victim.get_hurt()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	audio.volume_db = -5

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	audio.volume_db = -80

func _on_timer_timeout() -> void:
	var pos = position + Vector2(randf_range(-radious, radious), randf_range(-radious, radious))
	var sprite = Sprite.instantiate()
	sprite.position = pos
	get_parent().add_child(sprite)

func get_hurt() -> void:
	SoundManager.create_sound("Screem")
	health -= 1
	anim.stop()
	anim.play("Hurt")
	if health < 0:
		queue_free()

func _on_detect_area_area_entered(area: Area2D) -> void:
	player = area.get_parent()
	$DetectArea.queue_free()

func _on_player_killer_body_entered(body: Node2D) -> void:
	victim = body

func _on_player_killer_body_exited(body: Node2D) -> void:
	victim = null
