extends Label

const main_class = preload("res://scripts/main.gd")

func change_text(input: Dictionary):
	#if not _check_key(input, Global.DEBUG_XRCAMERA3D):
		#return
	#if not _check_key(input, Global.DEBUG_XRORIGIN3D):
		#return
	var result_text: String = ""
	
	result_text += "-----XRServer:-----\n"
	result_text += "world_scale: " + str(XRServer.world_scale) + "\n"
	
	if input.has(Global.DEBUG_XRCAMERA3D):
		var xrcamera: XRCamera3D = input[Global.DEBUG_XRCAMERA3D]
		result_text += "-----XRCamera3D:-----\n"
		result_text += "position: " + str(xrcamera.position) + "\n"
		result_text += "transform(basis): " + str(xrcamera.transform.basis) + "\n"
		result_text += "transform(origin): " + str(xrcamera.transform.origin) + "\n"
	
	if input.has(Global.DEBUG_XRORIGIN3D):
		var xrorigin: XROrigin3D = input[Global.DEBUG_XRORIGIN3D]
		result_text += "-----XROrigin3D:-----\n"
		result_text += "position: " + str(xrorigin.position) + "\n"
		result_text += "transform: " + str(xrorigin.transform) + "\n"
		result_text += "World Scale: " + str(xrorigin.world_scale) + "\n"
	
	if input.has(Global.DEBUG_WEBXRINTERFACE):
		var webxr_interface: WebXRInterface = input[Global.DEBUG_WEBXRINTERFACE]
		result_text += "-----XR Interface:-----\n"
		result_text += "Reference space type:" + webxr_interface.reference_space_type + "\n"
		result_text += "Required features:" + webxr_interface.required_features + "\n"
		result_text += "Optional features:" + webxr_interface.optional_features + "\n"
		result_text += "Enabled features:" + webxr_interface.enabled_features + "\n"
	
	if input.has(Global.DEBUG_XFORM_TRANSFORM) or input.has(Global.DEBUG_XFORM_NODE):
		result_text += "-----XForm:----- \n"
	
	if input.has(Global.DEBUG_XFORM_TRANSFORM):
		var transform: Transform3D = input[Global.DEBUG_XFORM_TRANSFORM]
		result_text += "transform: \n"
		result_text += "X: " + str(transform.basis.x) + "\n"
		result_text += "Y: " + str(transform.basis.y) + "\n"
		result_text += "Z: " + str(transform.basis.z) + "\n"
		result_text += "Origin: " + str(transform.origin) + "\n"
	
	if input.has(Global.DEBUG_XFORM_NODE):
		var node: Node3D = input[Global.DEBUG_XFORM_NODE]
		result_text += "node: \n"
		result_text += "transform: \n"
		result_text += "X: " + str(node.transform.basis.x) + "\n"
		result_text += "Y: " + str(node.transform.basis.y) + "\n"
		result_text += "Z: " + str(node.transform.basis.z) + "\n"
		result_text += "Origin: " + str(node.transform.origin) + "\n"
		result_text += "position:" + str(node.position) + " \n"
	
	if input.has(Global.DEBUG_RAY_MODE):
		var ray_mode: WebXRInterface.TargetRayMode = input[Global.DEBUG_RAY_MODE]
		result_text += "Ray Mode: " + str(Global.DEBUG_RAY_MODE_DICT_STR[ray_mode]) + "\n"
	
	if input.has(Global.DEBUG_TRACKER_SELECT):
		var tracker: XRPositionalTracker = input[Global.DEBUG_TRACKER_SELECT]
		var transform: Transform3D = tracker.get_pose("default").transform
		result_text += "-----XRPositionalTracker (Select):------\n"
		result_text += "XRPositionalTracker:\n"
		result_text += "get_pose():\n"
		result_text += "transform(basis):" + str(transform.basis) + "\n"
		result_text += "transform(origin):" + str(transform.origin) + "\n"
	
	if input.has(Global.DEBUG_TRACKER_SELECT_START):
		var tracker: XRPositionalTracker = input[Global.DEBUG_TRACKER_SELECT_START]
		var transform: Transform3D = tracker.get_pose("default").transform
		result_text += "-----XRPositionalTracker (Select Start):------\n"
		result_text += "XRPositionalTracker:\n"
		result_text += "get_pose():\n"
		result_text += "transform(basis):" + str(transform.basis) + "\n"
		result_text += "transform(origin):" + str(transform.origin) + "\n"
		
		if input.has(Global.DEBUG_TRACKER_TARGET):
			var tracker_target: Node3D = input[Global.DEBUG_TRACKER_TARGET]
			result_text += "-----XRPositionalTracker Target (Select Start):------\n"
			result_text += "\ttransform(basis):" + str(tracker_target.transform.basis) + "\n"
			result_text += "\ttransform(origin):" + str(tracker_target.transform.origin) + "\n"
	
	if input.has(Global.DEBUG_HEAD_CONTROLLER):
		var head_controller:XRController3D = input[Global.DEBUG_HEAD_CONTROLLER]
		result_text += "-----HeadController:------\n"
		result_text += "transform(basis): " + str(head_controller.transform.basis) + "\n"
		result_text += "transform(origin): " + str(head_controller.transform.origin) + "\n"
	
	if input.has(Global.DEBUG_RAYCAST3D):
		var ray_cast:RayCast3D = input[Global.DEBUG_RAYCAST3D]
		result_text += "-----RayCast3D:------\n"
		result_text += "is_colliding(): " + str(ray_cast.is_colliding()) + "\n"
		result_text += "get_collision_point(): " + str(ray_cast.get_collision_point()) + "\n"
		result_text += "get_collider(): " + str(ray_cast.get_collider()) + "\n"
		
	if input.has(Global.DEBUG_RAYCAST3D_DRAG):
		var ray_cast:RayCast3D = input[Global.DEBUG_RAYCAST3D_DRAG]
		result_text += "-----RayCast3D (Drag):------\n"
		result_text += "is_colliding(): " + str(ray_cast.is_colliding()) + "\n"
		result_text += "get_collision_point(): " + str(ray_cast.get_collision_point()) + "\n"
		result_text += "get_collider(): " + str(ray_cast.get_collider()) + "\n"
	
	if input.has(Global.DEBUG_MAIN):
		var main: main_class = input[Global.DEBUG_MAIN]
		var drag_tracker = main.drag_tracker
		
		result_text += "----main.gd-----\n"
		result_text += "selected_object = " + str(main.selected_object) + "\n"
		result_text += "drag_tracker = " + str(drag_tracker) + "\n"
	
	if input.has(Global.DEBUG_GESTURE_EVENT):
		var event:InputEventPanGesture = input[Global.DEBUG_GESTURE_EVENT]
		result_text += "---InputEventPanGesture----\n"
		result_text += "event.delta = " + str(event.delta) + "\n"
	
	text = result_text

func _check_key(dict: Dictionary, key: Variant) -> bool:
	if not dict.has(key):
		OS.alert("error_message.gd 5: no " + str(key) + "\ninput = " + str(dict))
		return false
	return true
