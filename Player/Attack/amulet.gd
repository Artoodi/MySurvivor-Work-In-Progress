extends Area2D

var level = 1
var damage = 5
var attack_size = 1.0
var knockback_amount = 100
var orbit_radius = 70.0
var orbit_speed = 1.5
var orbit_angle = 0.0
var amulet_index = 0
var amulet_total = 1

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	add_to_group("attack")
	match level:
		1:
			damage = 8
			orbit_speed = 1.5
			orbit_radius = 70.0
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100
		2:
			damage = 8
			orbit_speed = 1.8
			orbit_radius = 80.0
			attack_size = 1.15 * (1 + player.spell_size)
			knockback_amount = 110
		3:
			damage = 16
			orbit_speed = 2.3
			orbit_radius = 85.0
			attack_size = 1.3 * (1 + player.spell_size)
			knockback_amount = 125
		4:
			damage = 24
			orbit_speed = 2.5
			orbit_radius = 90.0
			attack_size = 1.5 * (1 + player.spell_size)
			knockback_amount = 140

	# 环绕初始分布
	orbit_angle = (amulet_index / float(amulet_total)) * TAU
	scale = Vector2.ONE * attack_size

func _physics_process(delta):
	if not is_instance_valid(player): return
	orbit_angle += orbit_speed * delta
	var offset = Vector2(orbit_radius, 0).rotated(orbit_angle)
	global_position = player.global_position + offset
	rotation = orbit_angle + PI / 2
