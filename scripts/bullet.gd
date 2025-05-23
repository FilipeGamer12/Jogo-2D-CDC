extends Area2D

var speed = 120
var direction = 1

func _physics_process(delta: float) -> void:
	position.x += speed * delta * direction
