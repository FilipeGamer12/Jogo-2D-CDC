extends CharacterBody2D
const SPEED = 50.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var timer: Timer = $Timer
@onready var det_chão: RayCast2D = $"Detector de chão"
@onready var det_player: RayCast2D = $"Detector de Player"

var direction = 1 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = SPEED * direction
	if not det_chão.is_colliding():
		direction *= -1
		scale.x *= -1
	move_and_slide()

func take_damage():
	print("danou-se")
	direction = 0
	anim.play("morto")
	hitbox.queue_free()
	timer.start()
	jump()
	collision_mask = 0

func _on_timer_timeout() -> void:
	queue_free()

func jump():
	velocity.y = -170
