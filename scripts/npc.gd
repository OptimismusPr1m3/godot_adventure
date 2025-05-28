extends StaticBody2D

@onready var canvas = $CanvasLayer
@onready var line = $CanvasLayer/Label

var can_talk: bool = false

var dialogue_lines1: Array[String] = ['Ich heisse Wernerwampe', 'Ich bin Werners Schlampe', 'Und ich liebe Kuchen !', 'Machs gut nech ?']
@export var dialogue_lines: Array[String]
var dialogue_index: int = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if dialogue_index < dialogue_lines.size() && can_talk:
			canvas.visible = true
			get_tree().paused = true
			print('TReee paused')
			line.text = dialogue_lines[dialogue_index]
			dialogue_index += 1
		else:
			canvas.visible = false
			get_tree().paused = false
			dialogue_index = 0

func controlDialogues():
	for i in dialogue_lines:
		print(i) 
