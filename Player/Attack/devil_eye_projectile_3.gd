extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 12
var knockback_amount = 120
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
			pass
		2:
			pass
		3:
			hp = 2
			speed = 150
			damage = 18
			knockback_amount = 130
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 2
			speed = 150
			damage = 30
			knockback_amount = 130
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
