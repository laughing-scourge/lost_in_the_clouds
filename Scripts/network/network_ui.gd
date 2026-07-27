extends Node2D

signal host_pressed



func _on_host_pressed() -> void:
	host_pressed.emit()
