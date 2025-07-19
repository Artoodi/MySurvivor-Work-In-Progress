extends Control

# 获取按钮和精灵的引用
@onready var btn_dorsia = $Btn_Dorsia
@onready var btn_maltheron = $Btn_Maltheron
@onready var dorsia_sprite = $DorsiaSprite
@onready var maltheron_sprite = $MaltheronSprite

func _ready():
	# 连接按钮信号
	btn_dorsia.pressed.connect(_on_dorsia_selected)
	btn_maltheron.pressed.connect(_on_maltheron_selected)
	
	# 初始显示状态（可选：高亮当前选择的角色）
	_update_character_display()
	

func _on_dorsia_selected():
	# 选择Dorsia角色
	Global.set_selected_character("Dorsia")
	print("选择了角色: Dorsia")
	_update_character_display()
	_start()

func _on_maltheron_selected():
	# 选择Maltheron角色
	Global.set_selected_character("Maltheron")
	print("选择了角色: Maltheron")
	_update_character_display()
	_start()

func _update_character_display():
	# 更新精灵显示状态，突出显示选中的角色
	var current_character = Global.get_selected_character_name()
	if current_character == "Dorsia":
		dorsia_sprite.frame = 1  # 激活状态帧
		maltheron_sprite.frame = 0  # 默认状态帧
		dorsia_sprite.modulate = Color.WHITE
		maltheron_sprite.modulate = Color(0.7, 0.7, 0.7)  # 变暗未选择的角色
	elif current_character == "Maltheron":
		dorsia_sprite.frame = 0  # 默认状态帧
		maltheron_sprite.frame = 1  # 激活状态帧
		dorsia_sprite.modulate = Color(0.7, 0.7, 0.7)  # 变暗未选择的角色
		maltheron_sprite.modulate = Color.WHITE
	else:
		# 没有选择任何角色时的默认状态
		dorsia_sprite.frame = 0
		maltheron_sprite.frame = 0
		dorsia_sprite.modulate = Color.WHITE
		maltheron_sprite.modulate = Color.WHITE
		
func _start():
	var level = "res://World/world.tscn"
	await get_tree().create_timer(2.0).timeout
	var _level = get_tree().change_scene_to_file(level)
