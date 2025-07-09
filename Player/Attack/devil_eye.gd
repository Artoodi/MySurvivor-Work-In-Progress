extends Node2D

var level = 1
var attack_speed = 4.0
var orbit_radius = 80.0
var orbit_speed = 1.0
var angle_offset = 0.0

# 投射物预加载
var projectile_1 = preload("res://Player/Attack/devil_eye_projectile_1.tscn")
var projectile_2 = preload("res://Player/Attack/devil_eye_projectile_2.tscn")
var projectile_3 = preload("res://Player/Attack/devil_eye_projectile_3.tscn")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var attackTimer = $AttackTimer
@onready var snd_attack = $snd_attack

var time_counter = 0.0

func _ready():
	update_devil_eye()
	attackTimer.timeout.connect(_on_attack_timer_timeout)
	attackTimer.start()

func _process(delta):
	if player:
		# 围绕玩家旋转
		time_counter += delta * orbit_speed
		var orbit_position = Vector2(
			cos(time_counter + angle_offset) * orbit_radius,
			sin(time_counter + angle_offset) * orbit_radius
		)
		global_position = player.global_position + orbit_position

func update_devil_eye():
	level = player.devil_eye_level
	match level:
		1:
			attack_speed = 4.0
			orbit_radius = 80.0
			orbit_speed = 1.0
		2:
			attack_speed = 3.5
			orbit_radius = 80.0
			orbit_speed = 1.0
		3:
			attack_speed = 3.0
			orbit_radius = 90.0
			orbit_speed = 1.2
		4:
			attack_speed = 2.5
			orbit_radius = 100.0
			orbit_speed = 1.5
	
	# 更新攻击速度（受到法术冷却影响）
	attackTimer.wait_time = attack_speed * (1 - player.spell_cooldown)

func _on_attack_timer_timeout():
	fire_projectiles()

func fire_projectiles():
	if player.enemy_close.size() > 0:
		# snd_attack.play()
		
		# 发射三种不同的投射物
		var targets = get_three_targets()
		
		# 投射物1 - 快速低伤害
		var proj1 = projectile_1.instantiate()
		proj1.global_position = global_position
		proj1.target = targets[0]
		proj1.level = level
		get_tree().current_scene.add_child(proj1)
		
		# 投射物2 - 中等速度中等伤害
		var proj2 = projectile_2.instantiate()
		proj2.global_position = global_position
		proj2.target = targets[1]
		proj2.level = level
		get_tree().current_scene.add_child(proj2)
		
		# 投射物3 - 慢速高伤害
		var proj3 = projectile_3.instantiate()
		proj3.global_position = global_position
		proj3.target = targets[2]
		proj3.level = level
		get_tree().current_scene.add_child(proj3)

func get_three_targets():
	var targets = []
	var available_enemies = player.enemy_close.duplicate()
	
	# 获取最多3个不同的目标
	for i in range(3):
		if available_enemies.size() > 0:
			var enemy = available_enemies.pick_random()
			targets.append(enemy.global_position)
			available_enemies.erase(enemy)
		else:
			# 如果敌人不够，使用随机方向
			var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			targets.append(global_position + random_direction * 200)
	
	return targets
