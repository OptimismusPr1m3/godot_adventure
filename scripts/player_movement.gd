extends CharacterBody2D
class_name Player

var speed:float = 100
@export var push_strength: float = 160

func _ready() -> void:
	if SceneManager.player_spawn:
		position = SceneManager.player_spawn

func _physics_process(delta: float) -> void:
	move_player()
	processCollision()
	
	move_and_slide()
	

func move_player():
	var moveVector: Vector2 = Input.get_vector("a", "d", "w", "s")
	
	velocity = moveVector * speed
	
	if moveVector.x > 0:
		$Area2D.position = Vector2(6, 2)
		$AnimatedSprite2D.play("walk_right")
	elif moveVector.x < 0:
		$Area2D.position = Vector2(-6, 2)
		$AnimatedSprite2D.play("walk_left")
	elif moveVector.y > 0:
		$Area2D.position = Vector2(0, 8)
		$AnimatedSprite2D.play("walk_down")
	elif moveVector.y < 0:
		$Area2D.position = Vector2(0, -6)
		$AnimatedSprite2D.play("walk_up")
	else:
		$AnimatedSprite2D.stop()

func processCollision():
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		var collider_node = collision.get_collider()
		if collider_node is RigidBody2D:
			var collision_normal: Vector2 = collision.get_normal()
			collider_node.apply_central_force(-collision_normal * push_strength)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('interactable'):
		body.can_interact = true
		print('JEtzt ist nen NPC drinnen')


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('interactable'):
		body.can_interact = false
		print('NPC ist nun wieder aus dem Area raus')
