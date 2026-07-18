class_name player_controller extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var input_dir: Vector2
var direction: Vector3
var last_direction: Vector3 = Vector3.FORWARD
@onready var head = $Pivot/heads/head


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	input_dir = Input.get_vector("rightward", "letfward", "backward", "forward")
	
	var move_dir = head.global_basis.x * input_dir.x + head.global_basis.z * input_dir.y
	move_dir.y = 0
	move_dir = move_dir.normalized()
	
	if move_dir:
		velocity.x = move_dir.x * SPEED
		velocity.z = move_dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if move_dir.length() > 0.01:
		var target_angle = atan2(move_dir.x, move_dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, delta * 10.0)
		
	move_and_slide()
	
