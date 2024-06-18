extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel

var time_elapsed: float = 0.0
var meat_counter: int = 0

func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	meat_label.text = str(meat_counter)

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
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	

func on_meat_collected(regenation_value:int) -> void:
	meat_counter += 1
	meat_label.text = str(meat_counter)
