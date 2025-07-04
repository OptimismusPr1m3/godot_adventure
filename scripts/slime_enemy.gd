extends CharacterBody2D

var target: Node2D
@export var speed: float
@export var acceleration: float = 2
@export var HP:int = 2

func _physics_process(delta: float) -> void:
	if HP <= 0:
		return
	chase_target()
	move_and_slide()

func chase_target():
	if target:
		var distace_to_player: Vector2
		distace_to_player = target.global_position - global_position
		
		var direction_normalized: Vector2 = distace_to_player.normalized()
		
		velocity = velocity.move_toward(direction_normalized * speed, acceleration)
		print(velocity)
		animate_enemy()

func animate_enemy():
	var normal_velocity: Vector2 = velocity.normalized()
	#print('Normale Veloc', normal_velocity)
	
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

func take_damag():
	var flash_red_light: Color = Color(50,0.5,0.5)
	var normal_color: Color = Color(1,1,1)
	modulate = flash_red_light
	play_damage_sfx()
	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(self):
		modulate = normal_color
		HP -= 1
	if HP <= 0:
		die()

func play_damage_sfx():
	$DamageSFX.play()

func die():
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred_thread_group("disabled", true)
	
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_player_detect_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
