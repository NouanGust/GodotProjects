class_name GameOverUI
extends CanvasLayer

@export var  restart_delay: float = 5.0

@onready var time_label: Label = %TimeLabel
@onready var monster_label: Label = %MonstersLabel

var restart_cooldown: float

func _ready():
	# Definindo valores dos labels
	time_label.text = GameManager.time_elapsed_string
	monster_label.text = str(GameManager.meat_counter)
	
	# Definindo valor do cooldown
	restart_cooldown = restart_delay

func _process(delta):
	# Atualizando cooldown
	restart_cooldown -= delta
	
	# recomeçando o jogo
	if restart_cooldown < 0:
		restart_game()


func restart_game() -> void:
	GameManager.reset()
	get_tree().reload_current_scene()
