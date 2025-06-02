extends StaticBody2D


@onready var sprite = $AnimatedSprite2D

var can_interact: bool = false
var is_open: bool = false
@export var chest_name: String

func _ready() -> void:
	if SceneManager.opened_chests.has(chest_name):
		is_open = true
		sprite.play("open")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && can_interact:
		toggleChest()


func toggleChest():
	if is_open:
		pass
	else:
		sprite.play("open")
		is_open = true
		$AudioStreamPlayer2D.play()
		$Sprite2D.visible = true
		$Timer.start()
		SceneManager.opened_chests.append(chest_name)

func _on_timer_timeout() -> void:
	$Sprite2D.visible = false
