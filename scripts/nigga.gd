extends CharacterBody2D
const SPEED = 120.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func take_damage():
	print("danou-se")
	anim.play("morto")
	hitbox.queue_free()
	timer.start()
	jump()
	collision_mask = 0

func _on_timer_timeout() -> void:
	queue_free()

func jump():
	velocity.y = -170
