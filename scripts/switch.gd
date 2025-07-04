extends StaticBody2D

@onready var sprite = $AnimatedSprite2D

var can_interact: bool = false
var is_activated: bool = false

signal switch_activated
signal switch_deactivated

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && can_interact:
		print('the player interacted with me !')
		if is_activated:
			deactivateSwitch()
		else:
			activateSwitch()

func activateSwitch():
	switch_activated.emit()
	$AudioStreamPlayer2D.pitch_scale = 1.0
	$AudioStreamPlayer2D.play()
	is_activated = true
	sprite.play("activated")

func deactivateSwitch():
	is_activated = false
	$AudioStreamPlayer2D.pitch_scale = 0.6
	$AudioStreamPlayer2D.play()
	switch_deactivated.emit()
	sprite.play('deactivated') 
