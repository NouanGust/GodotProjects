class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
var mobs_per_minute: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var cooldown: float = 0.0

func _process(delta: float):
	# Verificando se o jogo acabou
	if GameManager.is_game_over : return
	
	# Temporizador (colldown)
	cooldown -= delta
	if cooldown > 0: return
	
	# Freqência: Criaturas por minuto (CPM - MPM)
	# 60 criaturas/min = 1 criatura por seg
	# 120 criaturas/min = 2 criaturas por seg
	# intervalo em segundos entre criaturas => 60 / frequência
	var interval = 60.0 / mobs_per_minute
	cooldown = interval
	
	# Checar se o ponto é valido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return 
	
	
	# Intanciar uma criatura aleatória
	# Escolher uma criatura aleatória 
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	
	# Escolher um ponto aleatório
	# Intanciar a cena
	# Por na posição certa
	var creature = creature_scene.instantiate()
	creature.global_position = point
	
	# definir o parent
	get_parent().add_child(creature)


func get_point() -> Vector2:
	path_follow_2d.progress_ratio =randf()
	return path_follow_2d.global_position

