extends StaticBody2D

@onready var canvas = $CanvasLayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if canvas.visible:
			canvas.visible = false
		elif !canvas.visible && SceneManager.can_talk_to_npc:
			canvas.visible = true
			
