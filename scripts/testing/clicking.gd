extends Node

@onready var camera: Camera3D = get_parent()
@export var raycast: RayCast3D
@onready var zfar: float = abs(raycast.target_position.length())

var click_vector: Vector3

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			click_vector = camera.project_position(event.position, zfar)
			(raycast.get_node("Tracker") as Node3D).global_position = click_vector
