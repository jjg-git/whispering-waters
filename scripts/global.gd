extends Node

const DEBUG_XRCAMERA3D = "xrcamera3d"
const DEBUG_XRORIGIN3D = "xrorigin3d"
const DEBUG_WEBXRINTERFACE = "webxrinterface"

const DEBUG_XFORM_TRANSFORM = "xform_transform"
const DEBUG_XFORM_NODE = "xform_node"

const DEBUG_TRACKER_SELECT_START = "tracker_select_start"
const DEBUG_TRACKER_SELECT = "tracker_select"

const DEBUG_TRACKER_TARGET = "tracker_target"

const DEBUG_RAYCAST3D = "raycast3d"
const DEBUG_RAYCAST3D_DRAG = "raycast3d_drag"

const DEBUG_RAY_MODE = "ray_mode"

const DEBUG_HEAD_CONTROLLER = "head_controller"

const DEBUG_MAIN = "main"

const DEBUG_GESTURE_EVENT = "gesture_event"

const DEBUG_CAMERA_ZFAR = 50

const DEBUG_RAY_MODE_DICT_STR: Dictionary = {
	WebXRInterface.TargetRayMode.TARGET_RAY_MODE_GAZE: "Gaze",
	WebXRInterface.TargetRayMode.TARGET_RAY_MODE_SCREEN: "Screen",
	WebXRInterface.TargetRayMode.TARGET_RAY_MODE_TRACKED_POINTER: "Tracked Pointer",
	WebXRInterface.TargetRayMode.TARGET_RAY_MODE_UNKNOWN: "Unknown",
}
#const DEBUG_XFORM_NODE = "xform_node"
#const DEBUG_XFORM_NODE = "xform_node"

enum Mode {VELOCITY, RELATIVE}

func return_diff(camera: Camera3D, event: InputEvent) -> Vector3:
	
	var mode: Mode = Mode.VELOCITY
	var z_far:float = 30
	var projected_origin: Vector3 = \
		camera.project_position(Vector2.ZERO, z_far)
	var projected_relative: Vector3 = \
		camera.project_position(event.velocity if mode == Mode.VELOCITY else event.relative, z_far)
	#var projected_origin: Vector3 = camera.project_ray_origin(Vector2.ZERO)
	#var projected_relative: Vector3 = camera.project_ray_origin(event.velocity if mode == Mode.VELOCITY else event.relative)
	var diff: Vector3 = projected_relative - projected_origin
	var scale: float = 1
	var scaled_diff: Vector3 = diff * scale
	return scaled_diff
