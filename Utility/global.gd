extends Node

# 存储当前选择的角色名称
var selected_character: String = ""

# 存储当前加载的角色数据
var current_player_data = null

# 角色数据路径映射
var character_data_paths = {
	"Dorsia": "res://Player/CharacterData/Dorsia.tres",
	"Maltheron": "res://Player/CharacterData/Maltheron.tres"
}

func _ready():
	# 设置默认角色（可选）
	if selected_character == "":
		set_selected_character("Dorsia")

# 设置选择的角色并加载对应的数据
func set_selected_character(character_name: String):
	selected_character = character_name
	load_character_data(character_name)

# 加载角色数据
func load_character_data(character_name: String):
	if character_name in character_data_paths:
		var data_path = character_data_paths[character_name]
		current_player_data = load(data_path)
		if current_player_data:
			print("成功加载角色数据: " + character_name + " - " + data_path)
		else:
			print("错误: 无法加载角色数据 - " + data_path)
	else:
		print("错误: 未找到角色数据路径 - " + character_name)

# 获取当前选择的角色名称
func get_selected_character_name() -> String:
	return selected_character

# 获取当前角色的数据路径
func get_selected_character_path() -> String:
	if selected_character in character_data_paths:
		return character_data_paths[selected_character]
	return ""

# 获取当前加载的角色数据
func get_current_player_data():
	return current_player_data

# 重新加载当前角色数据
func reload_current_character_data():
	if selected_character != "":
		load_character_data(selected_character)

# 检查是否已选择角色
func has_character_selected() -> bool:
	return selected_character != "" and current_player_data != null

# 重置角色选择
func reset_character_selection():
	selected_character = ""
	current_player_data = null

# 添加新的角色数据路径（用于扩展）
func add_character_data_path(character_name: String, data_path: String):
	character_data_paths[character_name] = data_path
