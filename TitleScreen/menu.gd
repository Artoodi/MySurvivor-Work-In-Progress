extends Control

var level = "res://Utility/character_selector.tscn"

func _on_btn_play_click_end():
	var _level = get_tree().change_scene_to_file(level)

func _on_btn_exit_click_end():
	get_tree().quit()
