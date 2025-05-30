extends Node2D

@export var fase: String

func _on_play_again_pressed() -> void:
	var caminho_cena = "res://scenes/" + fase + ".tscn"
	get_tree().change_scene_to_file(caminho_cena)
