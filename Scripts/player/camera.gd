extends Node3D

enum CURRENT_LOOK_MODE{
	FP=1,
	TP=-1,
}

@onready var FP_postion: Vector3 = %FP_head_postion.position
@onready var TP_postion: Vector3 = %TP_head_postion.position

@export_category("reffrences")
@onready var character_body_3d: CharacterBody3D = $"../../.."

@export_category("FP")
@export_range(0.1,20.0) var fp_mouse_sens: float
@export_range(-90,90) var fp_pitch_clamp_MIN : float
@export_range(-90,90) var fp_pitch_clamp_MAX : float

@export_category("TP")
@export_range(0.1,20.0) var tp_mouse_sens: float
@export_range(-90,90) var tp_pitch_clamp_MIN : float
@export_range(-90,90) var tp_pitch_clamp_MAX : float

@export_category("Shared")
@export var switch_speed: float

var _rotation: Vector2
var mouse_delta: Vector2
var pitch_yaw: Vector2

var look_mode: CURRENT_LOOK_MODE = -1
var mouse_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED

func _enter_tree() -> void:
	
	print_debug(get_parent().get_parent().get_parent().name)


func _unhandled_input(event: InputEvent):
	if not is_multiplayer_authority():
		return
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_delta += -event.screen_relative


func _physics_process(delta: float) -> void:
	pass
	

func  _camera_process(delta: float) -> void:
	
	toggle_look_mode()
	camera_movement()
	
	if Input.is_action_just_pressed("ui_cancel"):
		if mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif mouse_mode == Input.MOUSE_MODE_VISIBLE:
			mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	mouse_delta = Vector2.ZERO
	Input.mouse_mode = mouse_mode
	


func camera_movement():
	var head: SpringArm3D = $"."
	if look_mode == 1: 
		head.spring_length = lerpf(head.spring_length,0,switch_speed)
		$Camera.fov = lerp($Camera.fov, 90.0 ,switch_speed)
		FP_look()
	if look_mode == -1:
		head.spring_length = lerpf(head.spring_length,6,switch_speed)
		$Camera.fov = lerp($Camera.fov, 120.0 ,switch_speed)
		TP_look()


func FP_look():
	_rotation += mouse_delta * fp_mouse_sens * 0.005
	_rotation.y = clampf(_rotation.y,deg_to_rad(fp_pitch_clamp_MIN),deg_to_rad(fp_pitch_clamp_MAX))
	
	global_transform.basis = Basis.from_euler(Vector3(_rotation.y,_rotation.x,0))


func TP_look():
	_rotation.x += mouse_delta.x * tp_mouse_sens * 0.005
	_rotation.y += mouse_delta.y * tp_mouse_sens * 0.005
	_rotation.y = clampf(_rotation.y,deg_to_rad(tp_pitch_clamp_MIN),deg_to_rad(tp_pitch_clamp_MAX))
	
	global_transform.basis = Basis.from_euler(Vector3(_rotation.y,_rotation.x,0))


func toggle_look_mode():
	if Input.is_action_just_pressed("camera_toggle"):
		look_mode*=-1
