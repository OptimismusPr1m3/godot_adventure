extends Area2D

var speed: float = 150
var acceleration: float = 5.0
var direction: Vector2
var lifeTime: int = 2

func _ready() -> void:
	await get_tree().create_timer(lifeTime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SceneManager.player_hp -= 1
		print("Flame has hit the Player !")
		body.onHit(self)
		queue_free()
