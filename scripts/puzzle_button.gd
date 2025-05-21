extends Area2D

@export var is_single_use: bool

var bodies_on_top: int = 0

signal pressed
signal unpressed


func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	if body.is_in_group('pushable') || body is Player:
		if bodies_on_top == 1:
			pressed.emit()
			print('now on top')
			print('Bodies:', bodies_on_top)
			$AnimatedSprite2D.play("pressed")


func _on_body_exited(body: Node2D) -> void:
	if is_single_use:
		return
	bodies_on_top -= 1
	if body.is_in_group('pushable') || body is Player:
		if bodies_on_top == 0:
			print('left Bodies:', bodies_on_top)
			unpressed.emit()
			$AnimatedSprite2D.play("unpressed")
