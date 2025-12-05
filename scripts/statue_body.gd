extends RigidBody3D

#func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	#if event is InputEventMouseMotion:
		#if event.button_mask == MOUSE_BUTTON_LEFT:
			#apply_force(Global.return_diff(camera, event))
			##$Label.text = str(diff)
