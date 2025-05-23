extends CharacterBody2D

@onready var animIdle: AnimatedSprite2D = $Idle
@onready var animRunning: AnimatedSprite2D = $Running

const SPEED = 60.0
const JUMP_VELOCITY = -330.0
@export var max_jump_count = 2
const STAND_PLAYER = preload("res://entitites/stand_player.tscn")
var jump_count = 0
var stand: CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump
}

var status: PlayerState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("down"):
		if stand == null:
			stand = STAND_PLAYER.instantiate()
			stand.position = position
			stand.player = self
			add_sibling(stand)
		else:
			stand.queue_free()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("punch"):
		stand.punch()
	
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
	
	move_and_slide()

## MÁQUINA DE ESTADOS

func go_to_idle_state():
	status = PlayerState.idle
	#animIdle.play()
	animRunning.visibility_layer = false
	animIdle.visibility_layer = true

func go_to_walk_state():
	status = PlayerState.walk
	#anim.play("walking")
	animRunning.visibility_layer = true
	animIdle.visibility_layer = false

func go_to_jump_state():
	status = PlayerState.jump
	#anim.play("jump")
	animRunning.visibility_layer = false
	animIdle.visibility_layer = true

func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
func jump_state():
	move()
	if is_on_floor():
		if velocity.x != 0:
			go_to_walk_state()
		else:
			go_to_idle_state()
		return

## MOVIMENTAÇÃO

func move():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x > 0:
		animIdle.flip_h = false
		animRunning.flip_h = false
		if stand != null:
			stand.inverter(false)
	elif velocity.x < 0:
		animIdle.flip_h = true
		animRunning.flip_h = true
		if stand != null:
			stand.inverter(true)
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		animRunning.play("jump")










func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("DeathZone"):
		print("e morreu")
		call_deferred("REreload_scene")
	elif area.is_in_group("LevelEnd"):
		var next_level = area.next_level
		if next_level:
			call_deferred("load_scene", next_level)
		else:
			push_error("Next level not found or defined")
	elif area.is_in_group("Enemies"):
		if velocity.y > 0:
			print("dale Coxa!")
			area.take_damage()
			go_to_jump_state()
		else:
			print("te mataram")
			call_deferred("REreload_scene")

#func reload_scene():
#	get_tree().reload_current_scene()
#func load_scene(scene_name: String):
#	get_tree().change_scene_to_file("res://cena/" + scene_name + ".tscn")
#func REreload_scene():
#	get_tree().change_scene_to_file("res://cena/game_over.tscn")
