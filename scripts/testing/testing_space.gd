extends Node3D

var mouse_button_pressed: bool = false
var last_collision_point: Vector3 = Vector3.ZERO
var last_collider_position: Vector3 = Vector3.ZERO
var last_event_position: Vector3 = Vector3.ZERO
var last_z_far: float = 0
var mouse_drag_offset: Vector3 = Vector3.ZERO

var selected_object: Node3D

var animation_done: bool = false

func _ready() -> void:
	set_process_unhandled_input(true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart_game"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_released("click"):
		if selected_object and selected_object is RigidBody3D:
			selected_object.gravity_scale = 1.0
		selected_object = null
	
	if Input.is_action_just_pressed("click"):
		var mouse_position = $Player/PlayerCamera.project_position( \
			get_viewport().get_mouse_position(), 
			5) - $Player.position
		
		%SelectRay.force_raycast_update()
		%SelectRay.target_position = mouse_position
		
		if %SelectRay.is_colliding():
			var collider = %SelectRay.get_collider()
			var raycasted_point: Vector3 = %SelectRay.get_collision_point()
			
			last_z_far = (raycasted_point - $Player.position).length()
			mouse_position = $Player/PlayerCamera.project_position( \
				get_viewport().get_mouse_position(), 
				last_z_far)
			
			mouse_drag_offset = collider.position - mouse_position
			selected_object = collider
	
	if Input.is_action_pressed("click"):
		if selected_object:
			var mouse_position = $Player/PlayerCamera.project_position( \
				get_viewport().get_mouse_position(), 
				last_z_far)
			var mouse_velocity = $Player/PlayerCamera.project_position( \
				Input.get_last_mouse_velocity(), 
				last_z_far) - $Player/PlayerCamera.project_position( \
				Vector2.ZERO, 
				last_z_far)
			
			var resulting_pos = mouse_position + mouse_drag_offset
			#$Player/Grabber.global_position = mouse_position - (last_event_position - last_collider_position)
			$Player/Grabber.global_position = resulting_pos
			$Player/Grabber/BodyOriginArea.global_position = selected_object.position
			$Player/Grabber/DeadZoneArea.moving_body = selected_object

			var rigid_body: RigidBody3D = selected_object as RigidBody3D
			selected_object.gravity_scale = 0
			
			var move_vector = resulting_pos - rigid_body.position
			var move_normalized = move_vector.normalized()
			var applied_force = move_vector
			#move_vector = move_vector.lerp(Vector3.ZERO, 0.5)
			print("testing_space.gd: applied_force.length() = ", applied_force.length())
			
			selected_object.global_position = resulting_pos
			#rigid_body.apply_central_force(lerp_force)
			#rigid_body.apply_central_impulse(applied_force)
			#rigid_body.apply_central_impulse(applied_force)
			#rigid_body.apply_central_force(Vector3.UP * 10)
			
			
			#selected_object.velocity = mouse_velocity


func _on_pressure_plates_finish() -> void:
	if not animation_done:
		$"WW-reveal/AnimationPlayer".play("Animation")
		animation_done = true
