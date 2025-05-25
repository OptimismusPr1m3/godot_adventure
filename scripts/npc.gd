extends StaticBody2D

@onready var canvas = $CanvasLayer
var can_talk: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if canvas.visible:
			canvas.visible = false
		elif !canvas.visible && can_talk:
			canvas.visible = true
			
