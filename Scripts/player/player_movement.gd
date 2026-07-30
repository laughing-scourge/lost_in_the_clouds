extends CharacterBody3D


@export var walk_speed = 5.0
@export var run_speed = 5.0
@export var rotate_speed = 5
@export var jump_velocity = 4.5


@onready var head: SpringArm3D = $Pivot/heads/head
@onready var components: Node = $components

var input_dir: Vector2
var direction: Vector3
var last_direction: Vector3 = Vector3.FORWARD
var wanted_speed: float
var auth: int

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	
	if not is_multiplayer_authority():
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_calculate_playermovement(delta)
	
	move_and_slide()
	
	

func _calculate_playermovement(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if not components.inventory_open:
		input_dir = Input.get_vector("rightward", "letfward", "backward", "forward")
	else:
		input_dir = Vector2.ZERO
	
	var move_dir = head.global_basis.x * input_dir.x + head.global_basis.z * input_dir.y
	move_dir.y = 0
	move_dir = -move_dir.normalized()
	
	wanted_speed = walk_speed
	
	if Input.is_action_pressed("sprint"):
		wanted_speed = run_speed
	
	if move_dir:
		velocity.x = move_dir.x * wanted_speed
		velocity.z = move_dir.z * wanted_speed
	else:
		velocity.x = move_toward(velocity.x, 0, wanted_speed)
		velocity.z = move_toward(velocity.z, 0, wanted_speed)
	
	if move_dir.length() > 0.01:
		var target_angle = atan2(move_dir.x, move_dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, delta * rotate_speed)
