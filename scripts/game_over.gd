extends Node2D

@export var fase: String

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file(Global.current_level)
