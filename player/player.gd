extends CharacterBody2D


const Shot := preload("res://player/shot.tscn")
const Text := preload("res://items/item_text.tscn")

const SPEED      : float = 120.0
const ACCEL      : float = 15.0
const AIR_ACCEL  : float = 10.0
const GRAV       : float = 620.0
const JUMP_FORCE : float = 220.0
const JUMP_MULTI : float = 0.7

var xDir : int = 0
var hp   : int = 4
var grounded      : bool = false
var canCancelJump : bool = true
var gunLoaded     : bool = true
var onVine        : bool = false
var stop          : bool = false

@export var hasGun : bool = false

@onready var body        := $Body
@onready var gun         := $Body/Gun
@onready var animPlayer  := $AnimationPlayer
@onready var animPlayer2 := $AnimationPlayer2
@onready var hud         := $Hud
@onready var cJTimer     := $CJTimer
@onready var pJTimer     := $PJTimer
@onready var hurtTimer   := $HurtTimer

@warning_ignore("unused_signal")
signal send_pos(pos : Vector2)
signal gun_shot()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_jump"):
		pJTimer.start()
	if event.is_action_pressed("ui_shoot") and gun.visible:
		if gunLoaded:
			SoundManager.create_sound("Boom")
			gunLoaded = false
			gun.frame = 0
			velocity.x = -JUMP_FORCE * 2 * body.scale.x
			shoot()
			emit_signal("gun_shot")
			if !is_on_floor():
				canCancelJump = false
				velocity.y = -JUMP_FORCE * 0.5
		else:
			SoundManager.create_sound("Empty")
			create_text("EMPTY")
	if event.is_action_pressed("ui_item"):
		hud.use_selected_item()

func _ready() -> void:
	SoundManager.create_sound("Start", true)
	if hasGun:
		gun.visible = true

func shoot() -> void:
	for i in 3:
		var shot = Shot.instantiate()
		shot.xDir = body.scale.x
		shot.global_position = gun.global_position - Vector2(shot.xDir * 8, 0) + \
		Vector2(shot.xDir * i * 5, randf_range(-5, 5))
		get_parent().add_child(shot)

func _physics_process(delta: float) -> void:
	if !stop:
		get_move_direction()
		set_look_dir()
		calculate_x_velocity(delta)
		apply_gravity(delta)
		cancel_jump()
		jump()
		update_move()
		emit_signal("send_pos", position)
		set_anim()

func get_move_direction() -> void:
	xDir = sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))

func set_look_dir() -> void:
	if xDir != 0:
		body.scale.x = xDir

func calculate_x_velocity(delta: float) -> void:
	velocity.x = lerp(velocity.x, xDir * SPEED, 1-pow(0.5, get_accel() * delta))

func get_accel() -> float:
	return ACCEL if is_on_floor() else AIR_ACCEL

func apply_gravity(delta :float) -> void:
	if !is_on_floor():
		velocity.y += GRAV * delta

func jump() -> void:
	if !pJTimer.is_stopped() and (grounded or !cJTimer.is_stopped() or onVine):
		grounded = false # -> To avoid double jump glitch.
		velocity.y = -JUMP_FORCE
		cJTimer.stop()
		pJTimer.stop()

func cancel_jump() -> void:
	if velocity.y < 0 and !Input.is_action_pressed("ui_jump") and canCancelJump:
		velocity.y *= JUMP_MULTI
		canCancelJump = false

func update_move() -> void:
	var wasGrounded = grounded
	move_and_slide()
	grounded = is_on_floor()
	if grounded and !wasGrounded:
		SoundManager.create_sound("Land")
	if wasGrounded and !grounded:
		cJTimer.start()
	if grounded:
		canCancelJump = true

func item_collected(frame : int):
	match frame:
		0:
			create_text("100")
		1:
			gun.visible = true
			create_text("SHOTGUN")
		2:
			create_text("PILLS" if hud.try_to_add_item(frame) else "NO SPACE")
		3:
			create_text("MEDKIT" if hud.try_to_add_item(frame) else "NO SPACE")
		4:
			create_text("AMMO" if hud.try_to_add_item(frame) else "NO SPACE")
	SoundManager.create_sound("Coin")

func create_text(message : String) -> void:
	var text = Text.instantiate()
	text.position = position + Vector2(-32, -48)
	text.text = message
	get_parent().add_child(text)

func set_anim() -> void:
	if is_on_floor():
		play_anim("Idle" if xDir == 0 else "Run")
	else:
		play_anim("Jump" if velocity.y < 0 else "Fall")

func get_hurt(damage : int = 1) -> void:
	if hurtTimer.is_stopped() or damage < 0:
		hp = clamp(hp - damage, 0, 4)
		hurtTimer.start()
		animPlayer2.play("Invis")
		hud.update_heart(hp)
		if damage > 0:
			create_text("OUCH")
			SoundManager.create_sound("Hurt")
		if hp <= 0:
			get_tree().call_deferred("reload_current_scene")

func play_anim(anim : String) -> void:
	if animPlayer.current_animation != anim:
		animPlayer.play(anim)

func _on_hurt_timer_timeout() -> void:
	animPlayer2.stop()
	body.visible = true
