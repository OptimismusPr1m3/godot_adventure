extends CharacterBody2D
class_name Player

@export var speed:float = 100
@export var knockback_strength: float = 150
@export var acceleration: float = 20
@export var push_strength: float = 360
@onready var hpSprite: AnimatedSprite2D = $CanvasLayer/AnimatedSprite2D

var is_attacking: bool = false
var can_interact: bool = false

func _ready() -> void:
	updateTreasureLabel()
	updateHpBar()
	if SceneManager.player_spawn:
		position = SceneManager.player_spawn


func _physics_process(delta: float) -> void:
	if SceneManager.player_hp <= 0:
		return
	if !is_attacking:
		move_player()
	
	processCollision()
	
	updateTreasureLabel()
	
	move_and_slide()
	if Input.is_action_just_pressed("interact") && !can_interact:
		attack()

func move_player():
	var moveVector: Vector2 = Input.get_vector("a", "d", "w", "s")
	
	velocity = velocity.move_toward(moveVector * speed, acceleration)
	
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
		can_interact = true
		print('JEtzt ist nen NPC drinnen')


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('interactable'):
		body.can_interact = false
		can_interact = false
		print('NPC ist nun wieder aus dem Area raus')

func updateTreasureLabel():
	%TreasureLabel.text = str(SceneManager.opened_chests.size())



func updateHpBar():
	if SceneManager.player_hp >= 3:
		hpSprite.play("3hp")
	elif SceneManager.player_hp == 2:
		hpSprite.play("2hp")
	elif SceneManager.player_hp == 1:
		hpSprite.play("1hp")
	else:
		hpSprite.play("0hp")
	die()

func _on_hit_box_area_2d_body_entered(body: Node2D) -> void:
	SceneManager.player_hp -= 1
	print(SceneManager.player_hp)
	updateHpBar()
	
	var distance_to_player: Vector2 = global_position - body.global_position
	var knockback_direction: Vector2 = distance_to_player.normalized()
	
	velocity += knockback_direction * knockback_strength
	
	var original_color = Color(1,1,1)
	var flas_white_color:Color = Color(50,50,50)
	modulate = flas_white_color
	$DamageSFX.play()
	await get_tree().create_timer(0.2).timeout
	modulate = original_color

func attack():
	if !is_attacking:
		$Sword/SwordSwingSFX.play()
		$Sword.visible = true
		%SwordArea2D.monitoring = true
		$AttackDurationTimer.start()
		is_attacking = true
		velocity = Vector2(0,0)
	
	var current_animation: String = $AnimatedSprite2D.animation
	if current_animation == "walk_right":
		$AnimatedSprite2D.play("attack_right")
		$AnimationPlayer.play("attack_right")
	elif current_animation == "walk_left":
		$AnimatedSprite2D.play("attack_left")
		$AnimationPlayer.play("attack_left")
	elif current_animation == "walk_down":
		$AnimatedSprite2D.play("attack_down")
		$AnimationPlayer.play("attack_down")
	elif current_animation == "walk_up":
		$AnimatedSprite2D.play("attack_up")
		$AnimationPlayer.play("attack_up")
	

func _on_sword_area_2d_body_entered(body: Node2D) -> void:
	var distance_to_player: Vector2 = body.global_position - global_position
	var knockBack_direction: Vector2 = distance_to_player.normalized()
	var knockbackStrength: float = 120
	
	body.velocity += knockBack_direction * knockbackStrength
	body.take_damag()

func _on_attack_duration_timer_timeout() -> void:
	$Sword.visible = false
	%SwordArea2D.monitoring = false
	is_attacking = false
	var current_animation: String = $AnimatedSprite2D.animation

	if current_animation == "attack_right":
		$AnimatedSprite2D.play("walk_right")
	elif current_animation == "attack_left":
		$AnimatedSprite2D.play("walk_left")
	elif current_animation == "attack_down":
		$AnimatedSprite2D.play("walk_down")
	elif current_animation == "attack_up":
		$AnimatedSprite2D.play("walk_up")

func die():
	if SceneManager.player_hp <= 0 && $DeathTimer.is_stopped():
		$AnimatedSprite2D.play("death")
		$DeathTimer.start()

func _on_death_timer_timeout() -> void:
	get_tree().call_deferred("reload_current_scene")
	SceneManager.player_hp = 3
