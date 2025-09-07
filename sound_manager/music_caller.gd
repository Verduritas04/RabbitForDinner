extends Node


@export var song : String = ""
@export var volume : float = -5
@export var restart : bool = false
@export var mute    : bool = false


func _ready() -> void:
	if !mute:
		SoundManager.play_music(song, restart)
		SoundManager.set_volume(volume)
	queue_free()
