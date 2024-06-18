extends Node

@export var speed: float = 1.0

var enemy: Enemy
var sprite: AnimatedSprite2D

func _ready() -> void:
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	pass

func _physics_process(delta: float) -> void:
	# Verificando se o jogo acabou
	if GameManager.is_game_over : return
	
	# Checando a posição e calculando a direção
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	
	# Movimento
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	
	# Girar Sprite
	if input_vector.x > 0:
		# Desligando o flip_h no Sprite 2d
		sprite.flip_h = false
	elif input_vector.x < 0:
		# Ligando o flip_h no Sprite2d
		sprite.flip_h = true
