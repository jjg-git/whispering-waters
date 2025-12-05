extends Area3D

var moving_body: RigidBody3D


func _on_area_entered(area: Area3D) -> void:
	if moving_body:
		moving_body.linear_velocity = Vector3.ZERO
