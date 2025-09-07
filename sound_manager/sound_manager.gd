extends Node


const Sound   = preload("res://sound_manager/sound.tscn")
const Sound2d = preload("res://sound_manager/2d_sound.tscn")
const Sound3d = preload("res://sound_manager/3d_sound.tscn")
const Music   = preload("res://sound_manager/music.tscn")

const MUSIC  : Dictionary = {
	"Intro" : {"sound" : preload("res://music/8-bit_slay_the_evil.ogg")},
	"Sad" : {"sound" : preload("res://music/slow_melancholic_theme_c64_style.ogg")}
}
const SOUNDS : Dictionary = {
	"Start" : {"sound" : preload("res://sfx/Checkpoint.wav"), "pitchRange" : [1.0, 1.0],
	"volume" : 0},
	"Land" : {"sound" : preload("res://sfx/Land.wav"), "pitchRange" : [0.9, 1.1],
	"volume" : 0},
	"Coin" : {"sound" : preload("res://sfx/Jump.wav"), "pitchRange" : [0.8, 1.2],
	"volume" : 8},
	"Select" : {"sound" : preload("res://sfx/Coin.wav"), "pitchRange" : [0.9, 1.1],
	"volume" : 0},
	"Use" : {"sound" : preload("res://sfx/Roll.wav"), "pitchRange" : [0.9, 1.1],
	"volume" : 8},
	"Boom" : {"sound" : preload("res://sfx/Boom.wav"), "pitchRange" : [0.9, 1.1],
	"volume" : 8},
	"Empty" : {"sound" : preload("res://sfx/BumpRoll.wav"), "pitchRange" : [0.9, 1.1],
	"volume" : 5},
	"Hurt" : {"sound" : preload("res://sfx/Hurt.wav"), "pitchRange" : [0.9, 1.1],
	"volume" : 5},
	"Screem" : {"sound" : preload("res://sfx/screem.wav"), "pitchRange" : [0.7, 1.3],
	"volume" : 0}
}

var currentSong : String = ""

@export var muteMusic : bool = false

@onready var music : Object


func _ready() -> void:
	create_music_node()

func create_music_node() -> void:
	var musicInst = Music.instantiate()
	add_child(musicInst)
	music = get_child(0)

func set_volume(volume : float) -> void:
	music.volume_db = volume

func play_music(songKey : String, restart : bool = false) -> void:
	if !muteMusic:
		if songKey == "":
			music.stop()
		elif currentSong != songKey or restart:
			music.stream = MUSIC[songKey]["sound"]
			music.play()
		currentSong = songKey

func create_sound(soundKey : String, global : bool = false) -> void:
	var soundInst = Sound.instantiate()
	instance_sound(soundInst, soundKey, null, global)

func create_sound2d(soundKey : String, position : Vector2, global : bool = false) -> void:
	var sound2dInst = Sound2d.instantiate()
	instance_sound(sound2dInst, soundKey, position, global)

func create_sound3d(soundKey : String, position : Vector3, global : bool = false) -> void:
	var sound3dInst = Sound3d.instantiate()
	instance_sound(sound3dInst, soundKey, position, global)

func rnd_audio(audios : Array) -> String:
	randomize()
	return audios[randi() % audios.size()]

func instance_sound(sound : Object, soundKey : String, u_position, global : bool) -> void:
	get_tree().current_scene.add_child(sound) if !global else add_child(sound)
	if u_position != null:
		sound.position = u_position
	sound.stream = SOUNDS[soundKey]["sound"]
	sound.pitch_scale = randf_range(SOUNDS[soundKey]["pitchRange"][0], SOUNDS[soundKey]["pitchRange"][1])
	sound.volume_db = SOUNDS[soundKey]["volume"]
	sound.call_deferred("play")
