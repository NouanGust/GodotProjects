class_name Player

extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 3

@export_category("Sword")
@export var sword_damage: int = 2

@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 30
@export var ritual_scene: PackedScene

@export_category("Life")
@export var health: int = 100
@export var max_health:int = 100
@export var death_prefab: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_colldown: float = 0.0

# Uma função que é chamada a cada frame do jogo
func _process(delta: float) -> void:
	
	# Mandando a posição 
	GameManager.player_position = position
	
	# Ler input
	read_input()
	
	# Processar ataque
	update_attack_cooldown(delta)
	
	# Ataque
	if Input.is_action_just_pressed("attack"):
		attack()

		
	# Processar animação e rotação de sprite
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
	
	# Processar dano
	update_hitbox_detection(delta)
	
	# Ritual
	update_ritual(delta)

# Uma função ligada a física do jogo 
func _physics_process(_delta: float) -> void:
	
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	
	# Atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func read_input() -> void:
	
	# Obter o input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Lidando com deadzone
	var _deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation() -> void:
	
	# Trocar Animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
	
		# Girar Sprite
	if input_vector.x > 0:
		# Desligando o flip_h no Sprite 2d
		sprite.flip_h = false
	elif input_vector.x < 0:
		# Ligando o flip_h no Sprite2d
		sprite.flip_h = true

func attack() -> void:
	
	if is_attacking:
		return

	# Tocar animação
	animation_player.play("attack_side_1")
	
	# Configurar temporizador
	attack_cooldown = 0.6
	
	# Marcar ataque
	is_attacking = true

func deal_damage_to_enemies() -> void:
	# Encontrar inimigos na area da espada
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		# verificar se o corpo é um inimigo
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			# Calcular direção e dot product
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				# Dar dano
				enemy.damage(sword_damage)

func update_ritual(delta: float) -> void:
	# Atualizar temporizador
	ritual_colldown -= delta
	if ritual_colldown > 0: return
	# Resetar temporizador
	ritual_colldown = ritual_interval
	
	# Criar ritual
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)

func update_hitbox_detection(delta: float) -> void:
	# Temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	# Frequência (2x por segundo)
	hitbox_cooldown = 0.5
	
	
	# Detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			# Processar dano
			damage(enemy.emeny_damage)


func damage(amount: int) -> void:
	if health <= 0: return
	
	# Processando dano
	health -= amount
	print("Jogador recebeu dano de ", amount, ". A vida total é de ", health)
	
	# Piscar inimigo
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Processando death
	if health <= 0:
		die()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount,". A vida total é de ",health, "/",  max_health)
	return health

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	# destruindo a entidade
	print("Player Morreu!")
	queue_free()



