extends Node3D

@export var debug_fly_speed: float = 1.0:
	set(value):
		fly_speed = value
var fly_speed:float = debug_fly_speed
const SCROLL_FACTOR := 0.4

var movement_direction: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_location"):
		var origin: Transform3D = Transform3D()
		origin.origin.y = 2 
		transform = origin
	_change_fly_speed()
	_movement(delta)
	#_look()


func _movement(delta: float) -> void:
	var input: Vector2 = Input.get_vector("strife_left", "strife_right", "forward", "backward")
	var input_elevate: float = Input.get_axis("falling", "rising")
	var move := input * fly_speed * delta
	var elevate := input_elevate * fly_speed * delta
	
	transform.origin += $PlayerCamera.transform.basis.x * move.x
	transform.origin += $PlayerCamera.transform.basis.z * move.y
	transform.origin += $PlayerCamera.transform.basis.y * elevate


func _look() -> void:
	if Input.is_action_pressed("look"):
		var mouse_vector := Input.get_last_mouse_velocity() * 0.01
		$PlayerCamera.transform.basis = \
			$PlayerCamera.transform.basis.rotated(\
			Vector3.UP,
			deg_to_rad(-mouse_vector.x))
		$PlayerCamera.transform.basis = \
			$PlayerCamera.transform.basis.rotated(\
			$PlayerCamera.transform.basis.x, \
			deg_to_rad(-mouse_vector.y))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT or \
			event.button_mask == MOUSE_BUTTON_MASK_RIGHT | MOUSE_BUTTON_MASK_LEFT:
			var mouse_vector: Vector2 = event.relative * 0.6
			$PlayerCamera.transform.basis = \
				$PlayerCamera.transform.basis.rotated(\
				Vector3.UP,
				deg_to_rad(-mouse_vector.x))
			$PlayerCamera.transform.basis = \
				$PlayerCamera.transform.basis.rotated(\
				$PlayerCamera.transform.basis.x, \
				deg_to_rad(-mouse_vector.y))


func _change_fly_speed() -> void:
	if Input.is_action_just_released("speed_up"):
		fly_speed += SCROLL_FACTOR
		print(fly_speed)
	if Input.is_action_just_released("slow_down"):
		fly_speed -= SCROLL_FACTOR
		print(fly_speed)
		
	fly_speed = max(fly_speed, 0)
