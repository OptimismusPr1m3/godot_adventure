extends CharacterBody2D

var target: Node2D
@export var speed: float


func _physics_process(delta: float) -> void:
	chase_target()
	move_and_slide()

func chase_target():
	if target:
		var distace_to_player: Vector2
		distace_to_player = target.global_position - global_position
		
		var direction_normalized: Vector2 = distace_to_player.normalized()
		
		velocity = direction_normalized * speed
		animate_enemy()

func animate_enemy():
	var normal_velocity: Vector2 = velocity.normalized()
	print('Normale Veloc', normal_velocity)
	
	Vector2(10,10).normalized() # --> ist 0.707 , 0.707 :D
	
	if normal_velocity.x > 0.707:
		#move right
		$AnimatedSprite2D.play("move_right")
	elif normal_velocity.x < -0.707:
		#move left
		$AnimatedSprite2D.play("move_left")
	elif normal_velocity.y < -0.707:
		#move up
		$AnimatedSprite2D.play("move_up")
	elif normal_velocity.y > 0.707:
		#move down
		$AnimatedSprite2D.play("move_down")

func _on_player_detect_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
