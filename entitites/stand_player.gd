extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -400.0

var player: CharacterBody2D

func _physics_process(delta: float) -> void:
	position = player.position + Vector2(-20, -30)
