extends Area2D

var level = 1
var hp = 1
var speed = 60  # 慢速
var damage = 25  # 高伤害
var knockback_amount = 200  # 高击退
var attack_size = 1.0

var direction = Vector2.ZERO
var lifetime = 5.0  # 火球存在时间

@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $AnimatedSprite2D  # AnimatedSprite2D节点
signal remove_from_array(object)

func _ready():
	# 添加到attack组
	add_to_group("attack")
	
	# 播放火球动画
	if animated_sprite:
		animated_sprite.play("default")  # 播放默认动画，您可以改为您的动画名称
	
	# 随机选择方向
	var random_angle = randf() * 2 * PI
	direction = Vector2(cos(random_angle), sin(random_angle))
	rotation = direction.angle()
	
	# 根据等级设置属性
	match level:
		1:
			hp = 1
			speed = 60
			damage = 25
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
			lifetime = 5.0
		2:
			hp = 1
			speed = 70
			damage = 30
			knockback_amount = 220
			attack_size = 1.1 * (1 + player.spell_size)
			lifetime = 6.0
		3:
			hp = 1
			speed = 80
			damage = 40
			knockback_amount = 250
			attack_size = 1.2 * (1 + player.spell_size)
			lifetime = 7.0
		4:
			hp = 1
			speed = 90
			damage = 50
			knockback_amount = 300
			attack_size = 1.3 * (1 + player.spell_size)
			lifetime = 8.0
	
	# 设置缩放
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1) * attack_size, 0.3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	# 设置生存时间
	var lifetime_timer = Timer.new()
	add_child(lifetime_timer)
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	lifetime_timer.start()

func _physics_process(delta):
	position += direction * speed * delta

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		create_explosion_effect()
		emit_signal("remove_from_array", self)
		queue_free()

func _on_lifetime_timeout():
	# 时间到了也要爆炸
	create_explosion_effect()
	emit_signal("remove_from_array", self)
	queue_free()

func create_explosion_effect():
	var explosion_tween = create_tween()
	explosion_tween.set_parallel(true)
	explosion_tween.tween_property(self, "scale", scale * 2.0, 0.3)
	explosion_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.3)
	await explosion_tween.finished
