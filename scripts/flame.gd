extends CharacterBody2D

var target: Node2D
var HP: int = 2
var hasFirstHit: bool = false
var rangedSpeed: float = 5
var hasShot: bool = false

@export var speed: float = 40
@export var acceleration: float = 2

@onready var throwableFlame = preload("res://scenes/enemies/flame_throwable.tscn")

func _physics_process(delta: float) -> void:
	if HP <= 0:
		return

	chasePlayer()
	move_and_slide()

func chasePlayer():
	if target:
		#var distance_to_player: Vector2 = global_position - target.global_position # this lets the enemy run away from the player xD
		var distance_to_player: Vector2 = (target.global_position - global_position).normalized()
		
		velocity = velocity.move_toward(distance_to_player * speed, acceleration)
		#print('Chasing Player', velocity)
		if !hasShot:
			throwFlame(velocity)
		animate_enemy()

func throwFlame(direction: Vector2):
	var flame = throwableFlame.instantiate()
	flame.position = global_position
	flame.direction = (target.global_position - global_position).normalized()
	get_tree().current_scene.add_child(flame)
	hasShot = true

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
	#play_damage_sfx()
	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(self):
		modulate = normal_color
		HP -= 1
	if HP <= 0:
		die()

func die():
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred_thread_group("disabled", true)
	
	await get_tree().create_timer(.7).timeout #macht nen 0.7 sekunden Timer
	queue_free()

func _on_target_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		hasShot = false
