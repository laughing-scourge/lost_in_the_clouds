extends Node3D

enum CURRENT_LOOK_MODE{
	FP=1,
	TP=-1,
}

@onready var FP_postion: Vector3 = %FP_head_postion.position
@onready var TP_postion: Vector3 = %TP_head_postion.position

@export_category("reffrences")
@export var player:player_controller

@export_category("FP")
@export var fp_mouse_sens: float
@export_range(-90,90) var fp_pitch_clamp_MIN : float
@export_range(-90,90) var fp_pitch_clamp_MAX : float

@export_category("TP")
@export var tp_mouse_sens: float
@export_range(-90,90) var tp_pitch_clamp_MIN : float
@export_range(-90,90) var tp_pitch_clamp_MAX : float

@export_category("Shared")
@export var switch_speed: float

var _rotation: Vector2
var mouse_delta: Vector2
var pitch_yaw: Vector2

var look_mode: CURRENT_LOOK_MODE = 1
var mouse_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_delta += -event.screen_relative  


func _physics_process(delta: float) -> void:
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
	if look_mode == 1: 
		FP_look()
	if look_mode == -1:
		TP_look()

func FP_look():
	_rotation += -mouse_delta * fp_mouse_sens
	_rotation.y = clampf(_rotation.y,deg_to_rad(fp_pitch_clamp_MIN),deg_to_rad(fp_pitch_clamp_MAX))
	
	global_transform.basis = Basis.from_euler(Vector3(_rotation.y,-_rotation.x,0))

func TP_look():
	_rotation += -mouse_delta * tp_mouse_sens
	_rotation.y = clampf(_rotation.y,deg_to_rad(tp_pitch_clamp_MIN),deg_to_rad(tp_pitch_clamp_MAX))
	
	global_transform.basis = Basis.from_euler(Vector3(-_rotation.y,_rotation.x,0))
	


func move_camera():
	var wanted_postion: Vector3
	if look_mode == 1:
		wanted_postion = FP_postion
	if look_mode == -1:
		wanted_postion = TP_postion
	$Camera.position = $Camera.position.lerp(wanted_postion,switch_speed)

func toggle_look_mode():
	if Input.is_action_just_pressed("camera_toggle"):
		look_mode*=-1
	move_camera()
