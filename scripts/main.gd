extends Node3D

enum Session {VR, AR, INLINE}
var sessions: Dictionary = {
	Session.VR: "immersive-vr",
	Session.AR: "immersive-ar",
	Session.INLINE: "inline",
}

var expected_session = sessions[Session.AR]
var is_supported:bool = false

var webxr_interface:WebXRInterface

@onready var debug_text = %DebugText
var debug_info: Dictionary = {}

var required_features = "unbounded"
var optional_features = "viewer, local-floor, local"
var requested_reference = 'unbounded, viewer, local, local-floor'

var touch_tracker: XRPositionalTracker
var drag_tracker: XRPositionalTracker
var selected_object: Node3D

var trackers: Array[Node3D] = []

# Called when the  enters the scene tree for the first time.
func _ready() -> void:
	$Startup/AttemptLabel.text = "Attempt: 98" 
	
	$Startup.visible = true
	$AR_UI.visible = false
	
	%Start.disabled = true
	webxr_interface = XRServer.find_interface("WebXR")
	
	if webxr_interface:
		%Start.pressed.connect(self._initiate_xr)
		
		webxr_interface.session_started.connect(self._on_webxr_interface_session_started)
		webxr_interface.session_failed.connect(self._on_webxr_interface_session_failed)
		webxr_interface.session_supported.connect(self._on_webxr_interface_session_supported)
		webxr_interface.session_ended.connect(self._on_webxr_interface_session_ended)
		
		webxr_interface.select.connect(self._on_webxr_select)
		webxr_interface.selectstart.connect(self._on_webxr_selectstart)
		webxr_interface.selectend.connect(self._on_webxr_selectend)
		
		webxr_interface.is_session_supported(expected_session)

	
	%RequestedBoxes.get_features(requested_reference)
	%RequiredBoxes.get_features(required_features)
	%OptionalBoxes.get_features(optional_features)
	
	%RequestedBoxes.feature_changed.connect(
		%RequiredBoxes.on_reference_space_changed
	)
	%RequestedBoxes.feature_changed.connect(
		%OptionalBoxes.on_reference_space_changed
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventPanGesture:
		debug_info[Global.DEBUG_GESTURE_EVENT] = event

func _initiate_xr() -> void:
	webxr_interface.session_mode = expected_session
	webxr_interface.requested_reference_space_types = requested_reference
	webxr_interface.required_features = required_features
	webxr_interface.optional_features = optional_features
	#webxr_interface.optional_features = 'bounded-floor'
	
	if not webxr_interface.initialize():
		_set_error_message("Cannot initialize XR for some reason")
	
	_set_error_message("Reference space: " + webxr_interface.reference_space_type)

func _update_camera_info() -> void:
	#debug_info[Global.DEBUG_XRCAMERA3D] = get_node("XROrigin3D/XRCamera3D")
	#debug_info[Global.DEBUG_XRORIGIN3D] = get_node("XROrigin3D")
	#debug_info[Global.DEBUG_WEBXRINTERFACE] = webxr_interface
	debug_text.change_text(debug_info)
	#
	#%CameraDebug.transform = \
		#$XROrigin3D/XRCamera3D.transform # / $XROrigin3D.world_scale if $AR_UI/Debug/VBoxContainer/CheckBox.button_pressed else 1

func _process(_delta: float) -> void:
	if get_viewport().use_xr:
		_update_camera_info()

func _physics_process(_delta: float) -> void:
	if drag_tracker:
		var pose: XRPose = drag_tracker.get_pose("default")
		var xform: Transform3D = pose.transform * ($XROrigin3D.world_scale if $AR_UI/Debug/VBoxContainer/CheckBox.button_pressed else 1) 
		xform.basis = xform.basis.orthonormalized()
		%Tracker.transform = xform
		
		if selected_object:
			%Touch.transform = xform
			#if $AR_UI/Debug/VBoxContainer/CheckBox4.button_pressed:
				#selected_object.drag(xform * %Touch/Holder.transform)
			#else:
				#selected_object.drag(%Touch/Holder.transform * xform)
			var final_transform: Transform3D = selected_object.global_transform
			final_transform.origin = %Touch/Holder.global_transform.origin
			#selected_object.drag(final_transform)
			selected_object.transform = final_transform
			


#region WebXR signals
func _on_webxr_interface_session_started() -> void:
	get_viewport().use_xr = true
	get_viewport().transparent_bg = true
	%WSSpinner.value = $XROrigin3D.world_scale
	$Startup.visible = false
	$AR_UI.visible = true
	
	#OS.alert("Session started") # This caused the XR session to not start for some reason
	
	_update_camera_info()

func _on_webxr_interface_session_failed(message: String) -> void:
	var alert_message := "Session failed!\n"+message
	OS.alert(alert_message)
	_set_error_message(alert_message)
	$Startup.visible = true
	$AR_UI.visible = false
	
func _on_webxr_interface_session_ended() -> void:
	get_viewport().use_xr = false
	get_viewport().transparent_bg = true
	
	$Startup.visible = true
	$AR_UI.visible = false
	
	#OS.alert("Session ended")

func _on_webxr_interface_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == expected_session:
		is_supported = supported
		if supported:
			%Start.disabled = false
	else:
		_set_error_message(session_mode + " is not supported.")

func _set_error_message(message: String) -> void:
	%ErrorMessage.text = message

#endregion

func _on_ws_spinner_value_changed(value: float) -> void:
	$XROrigin3D.world_scale = value

func _on_webxr_select(input_source_id: int) -> void:
	var tracker: XRPositionalTracker = webxr_interface.get_input_source_tracker(input_source_id)
	var xform = tracker.get_pose("default").transform * ($XROrigin3D.world_scale if $AR_UI/Debug/VBoxContainer/CheckBox.button_pressed else 1) 
	var collision_point: Vector3 = Vector3.ZERO

	xform.basis = xform.basis.orthonormalized()
	#%XRRayCast3DSelect.enabled = true
	%XRRayCast3DSelect.transform = xform
	%XRRayCast3DSelect.force_raycast_update()
	
	if %XRRayCast3DSelect.is_colliding():
		#var collider = %XRRayCast3DSelect.get_collider()
		collision_point = %XRRayCast3DSelect.get_collision_point()
		%RayTarget4.position = collision_point
		
		#%Touch/Holder.global_position = collider.global_position
		#selected_object = collider
		ray_cast_perform(%XRRayCast3DSelect)
		
		#%XRRayCast3DSelect.enabled = false if $AR_UI/Debug/VBoxContainer/CheckBox3.button_pressed else true
	
	debug_info[Global.DEBUG_TRACKER_SELECT] = tracker
	debug_info[Global.DEBUG_RAYCAST3D] = %XRRayCast3DSelect

func _on_webxr_selectstart(input_source_id: int) -> void:
	var tracker: XRPositionalTracker = webxr_interface.get_input_source_tracker(input_source_id)
	var xform = tracker.get_pose("default").transform * ($XROrigin3D.world_scale if $AR_UI/Debug/VBoxContainer/CheckBox.button_pressed else 1) 

	drag_tracker = tracker
	xform.basis = xform.basis.orthonormalized()
	%XRRayCast3DDrag.transform = xform
	
	%XRRayCast3DDrag.force_raycast_update()
	if %XRRayCast3DDrag.is_colliding():
		var collider:Object = %XRRayCast3DDrag.get_collider()
		%Touch.transform = xform # Apply to parent node first before moving child node's global position
		%Touch/Holder.global_position = collider.global_position
		selected_object = collider
	
	debug_info[Global.DEBUG_TRACKER_SELECT_START] = drag_tracker
	debug_info[Global.DEBUG_RAYCAST3D_DRAG] = %XRRayCast3DDrag
	debug_info[Global.DEBUG_TRACKER_TARGET] = %Tracker
	debug_info[Global.DEBUG_MAIN] = self
	
	
	#%XForm.transform = xform

func _on_webxr_selectend(_input_source_id: int) -> void:
	%XRRayCast3DDrag.enabled = false
	%XRRayCast3DSelect.enabled = false
	selected_object = null
	#%Touch/Holder.position = Vector3.ZERO

func _on_optional_boxes_feature_changed(features: String) -> void:
	optional_features = features
	_set_error_message("optional_features = " + optional_features)


func _on_required_boxes_feature_changed(features: String) -> void:
	required_features = features
	_set_error_message("required_features = " + required_features)


func _on_requested_box_feature_changed(features: String) -> void:
	requested_reference = features
	_set_error_message("requested_reference_space = " + requested_reference)


func ray_cast_perform(ray_cast: RayCast3D) -> void:
	var collider = ray_cast.get_collider()
	
	if collider is Interactable:
		#OS.alert("main.gd, ray_cast_perform():\ninside if-condition")
		collider.interact()

func ray_cast_drag(ray_cast: RayCast3D, xform: Transform3D) -> void:
	var collider = ray_cast.get_collider()
	
	if collider is Draggable:
		collider.drag(xform)

func _on_restart_button_up() -> void:
	get_tree().reload_current_scene()

func _on_open_option_pressed() -> void:
	%OptionPanel.visible = true
	%OptionPanel.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP


func _on_close_option_pressed() -> void:
	%OptionPanel.visible = false
	%OptionPanel.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE


func _on_pressure_plates_finish() -> void:
	%AnimationPlayer.play("Reveal")
