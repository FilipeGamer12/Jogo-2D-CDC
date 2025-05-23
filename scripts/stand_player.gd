extends CharacterBody2D
@onready var star_anim: AnimatedSprite2D = $Star_anim
@onready var damage: CollisionShape2D = $Area2D/damage
@onready var punch_time: Timer = $punch_time

const SPEED = 60.0

var player: CharacterBody2D
var status: StandState

enum StandState {
	idle,
	light_punch,
	punch,
	heavy_punch
}

var is_flipped = false

func _physics_process(delta: float) -> void:
	if is_flipped:
		position.x = move_toward(position.x, player.position.x + 10, SPEED * delta) 
	else:
		position.x = move_toward(position.x, player.position.x - 10, SPEED * delta)
	
	match status:
		StandState.idle:
			pass
		StandState.light_punch:
			pass
		StandState.punch:
			pass
		StandState.heavy_punch:
			pass

func inverter(flip):
	star_anim.flip_h = flip
	is_flipped = flip

## MÁQUINA DE ESTADOS

#func idle_state():

func punch():
	damage.process_mode = Node.PROCESS_MODE_ALWAYS
	punch_time.start()


func _on_punch_time_timeout() -> void:
	damage.process_mode = Node.PROCESS_MODE_DISABLED
