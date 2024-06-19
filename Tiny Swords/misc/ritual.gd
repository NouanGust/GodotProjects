extends Node2D

@export var damage_amount: int = 1

# Pegar uma Area 2d com colisão
@onready var area2d: Area2D = $Area2D
@onready var ritual_fx: AudioStreamPlayer = $RitualFx
func deal_damage():
	# get_overlaping_bodies
	var bodies = area2d.get_overlapping_bodies()
	
	# Checar se são inimigos
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			# Dar dano
			enemy.damage(damage_amount)
			# Tocar som
			ritual_fx.play()
	print("Ritual Damage")
