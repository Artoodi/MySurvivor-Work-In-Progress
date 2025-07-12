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
@onready var snd_attack = $AudioStreamPlayer2D

var time_counter = 0.0

func _ready():
	update_devil_eye()
	attackTimer.timeout.connect(_on_attack_timer_timeout)
	attackTimer.start()

func _process(delta):
	if player:
		# 围绕玩家旋转，但眼睛自身不旋转
		time_counter += delta * orbit_speed
		var orbit_position = Vector2(
			cos(time_counter + angle_offset) * orbit_radius,
			sin(time_counter + angle_offset) * orbit_radius
		)
		global_position = player.global_position + orbit_position
		# 移除自身旋转，保持固定方向

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
		# 播放音效
		if snd_attack and snd_attack.stream:
			snd_attack.play()
		
		# 根据等级决定发射的投射物类型，并受additional_attacks影响
		var targets = get_targets_for_level()
		
		# 计算额外发射次数（受ring道具影响）
		var extra_shots = player.additional_attacks
		
		# 发射基础投射物 + 额外投射物
		for shot in range(1 + extra_shots):
			# 投射物1 - 所有等级都有
			var proj1 = projectile_1.instantiate()
			proj1.global_position = global_position
			proj1.target = targets[0]
			proj1.level = level
			get_tree().current_scene.add_child(proj1)
			
			# 投射物2 - 等级2以上才有
			if level >= 2:
				var proj2 = projectile_2.instantiate()
				proj2.global_position = global_position
				proj2.target = targets[1]
				proj2.level = level
				get_tree().current_scene.add_child(proj2)
			
			# 投射物3 - 等级3以上才有
			if level >= 3:
				var proj3 = projectile_3.instantiate()
				proj3.global_position = global_position
				proj3.target = targets[2]
				proj3.level = level
				get_tree().current_scene.add_child(proj3)
			
			# 如果有多次发射，稍微延迟下一轮
			if shot < extra_shots:
				await get_tree().create_timer(0.1).timeout

func get_targets_for_level():
	var targets = []
	var available_enemies = player.enemy_close.duplicate()
	
	# 根据等级确定需要的目标数量
	var target_count = 1  # 等级1只需要1个目标
	if level >= 2:
		target_count = 2  # 等级2需要2个目标
	if level >= 3:
		target_count = 3  # 等级3需要3个目标
	
	# 为每轮发射获取足够的目标（考虑additional_attacks）
	var total_shots = 1 + player.additional_attacks
	var targets_needed = target_count * total_shots
	
	# 获取目标，如果敌人不够就重复使用
	for i in range(targets_needed):
		if available_enemies.size() > 0:
			var enemy = available_enemies.pick_random()
			targets.append(enemy.global_position)
			# 如果敌人不够，重新填充列表
			if i > 0 and i % available_enemies.size() == 0:
				available_enemies = player.enemy_close.duplicate()
		else:
			# 如果没有敌人，使用随机方向
			var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			targets.append(global_position + random_direction * 200)
	
	# 确保返回至少3个目标
	while targets.size() < 3:
		var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		targets.append(global_position + random_direction * 200)
	
	return targets
