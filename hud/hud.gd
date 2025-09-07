extends CanvasLayer


var selected : int = 0

@onready var health := $Health
@onready var slots  := $Slots
@onready var frame  := $Frame


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		selected += 1
		set_selected()
		SoundManager.create_sound("Select")
	elif event.is_action_pressed("ui_up"):
		selected -= 1
		set_selected()
		SoundManager.create_sound("Select")

func _ready() -> void:
	frame.modulate.a = 1.0
	set_selected()

func set_selected() -> void:
	if selected < 0:
		selected = slots.get_child_count() - 1
	elif selected > slots.get_child_count() - 1:
		selected = 0
	for i in slots.get_child_count():
		slots.get_child(i).boxSprite.frame = 0 if i == selected else 1

func try_to_add_item(itemFrame : int) -> bool:
	for slot in slots.get_children():
		if !slot.itemSprite.visible:
			slot.itemSprite.frame = itemFrame
			slot.itemSprite.visible = true
			return true
	return false

func use_selected_item() -> void:
	var slot = slots.get_child(selected)
	if slot.itemSprite.visible:
		SoundManager.create_sound("Use")
		slot.itemSprite.visible = false
		var parent = get_parent()
		match slot.itemSprite.frame:
			2:
				parent.get_hurt(-1)
				parent.create_text("+1 HP")
			3:
				parent.get_hurt(-2)
				parent.create_text("+2 HP")
			4:
				parent.gun.frame = 1
				parent.gunLoaded = true
				parent.create_text("RELOAD")

func update_heart(hp : int) -> void:
	health.frame = min(4 - hp, 3)
