extends Area2D

var level = 1
var hp = 1
var speed = 200
var damage = 3
var knockback_amount = 50
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle()
	
	match level:
		1:
			hp = 1
			speed = 200
			damage = 3
			knockback_amount = 50
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 200
			damage = 3
			knockback_amount = 50
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 1
			speed = 200
			damage = 3
			knockback_amount = 60
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 1
			speed = 300
			damage = 6
			knockback_amount = 60
			attack_size = 1.0 * (1 + player.spell_size)

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1) * attack_size, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	position += angle * speed * delta

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
