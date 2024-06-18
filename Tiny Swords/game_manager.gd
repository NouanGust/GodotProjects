extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_game_over: bool = false

var time_elapsed: float = 0.0
var time_elapsed_string: String
var meat_counter: int = 0

func _process(_delta: float):
	time_elapsed += _delta
	
	# Pegando tempo em segundos
	# floori() arredonda para baixo e retorna interiro
	# round() arredonda para baixo ou para cima dependendo do número
	# ceil() arrendonda para cima 
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	# Calculando os segundos e minutos
	# 02:59 => 179 segundos % 2 = 59
	var seconds: int = time_elapsed_in_seconds % 60
	# 03:00 => 180 segundos / 2 = 90
	var minutes: int = time_elapsed_in_seconds / 60
	# Atualizando o contador 
	time_elapsed_string = "%02d:%02d" % [minutes, seconds]

func end_game():
	# Verificando se o jogo acabou
	if is_game_over: return
	
	# Acabando o jogo e emitindo o sinal
	is_game_over = true
	game_over.emit()

func reset():
	# Resetando valores
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	
	# Desconectando os sinais
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
