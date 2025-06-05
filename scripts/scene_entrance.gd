extends Area2D

@export var new_scene: String

@export var player_other_scene_spawn: Vector2

func _ready() -> void:
	self.body_entered.connect(_char_entered)

func _char_entered(body: Node2D):
	if body is Player:
		SceneManager.player_spawn = player_other_scene_spawn
		print(SceneManager.player_spawn)

		get_tree().change_scene_to_file.call_deferred(new_scene)
