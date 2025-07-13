extends Resource

class_name PlayerData
# 角色数据
@export var display_name: String = "Default Player"  # 角色显示名称
@export var hp: int = 80  # 初始HP
@export var maxhp: int = 80  # 最大HP
@export var movement_speed: float = 50.0  # 移动速度
@export var sprite_texture: Texture2D  # 精灵纹理
@export var h_frames: int = 2

# 能力数据
@export var armor = 0
@export var speed = 0
@export var spell_cooldown: float =  0
@export var spell_size: float =  0
@export var additional_attacks = 0
