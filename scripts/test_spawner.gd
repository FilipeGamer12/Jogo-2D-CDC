extends Node2D

@export var enemy_scene: PackedScene

const ENEMY_DUMMY = preload("res://entitites/Enemy_Dummy.tscn")

func _ready():
	if enemy_scene == null:
		enemy_scene = ENEMY_DUMMY

	var existing_enemy = $Enemy_Dummy
	if existing_enemy:
		existing_enemy.connect("died", Callable(self, "_on_enemy_died"))

func spawn_enemy(pos: Vector2):
	var enemy = enemy_scene.instantiate()
	enemy.global_position = pos
	add_child(enemy)
	enemy.connect("died", Callable(self, "_on_enemy_died"))

func _on_enemy_died(pos: Vector2) -> void:
	print("Enemy morreu em ", pos)
	await get_tree().create_timer(2.0).timeout
	spawn_enemy(pos)
