extends Node2D

@export var creatures: Array[PackedScene]
@export var mobs_per_minute: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var colldown: float = 0.0

func _process(delta: float):
	# Temporizador (colldown)
	colldown -= delta
	if colldown > 0: return
	
	# Freqência: Criaturas por minuto (CPM - MPM)
	# 60 criaturas/min = 1 criatura por seg
	# 120 criaturas/min = 2 criaturas por seg
	# intervalo em segundos entre criaturas => 60 / frequência
	var interval = 60.0 / mobs_per_minute
	colldown = interval
	
	# Intanciar uma criatura aleatória
	# Escolher uma criatura aleatória 
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	
	# Escolher um ponto aleatório
	# Intanciar a cena
	# Por na posição certa
	var creature = creature_scene.instantiate()
	creature.global_position = get_point()
	
	# definir o parent
	get_parent().add_child(creature)


func get_point() -> Vector2:
	path_follow_2d.progress_ratio =randf()
	return path_follow_2d.global_position

