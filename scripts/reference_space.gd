extends FeatureAbstract

class_name RequestBoxes

func _ready() -> void:
	$UnboundedChkBx.toggled.connect(self._on_unboundedchkbx_toggled)
	$ViewerChkBx.toggled.connect(self._on_viewerchkbx_toggled)
	$LocalFloorChkBx.toggled.connect(self._on_localfloorchkbx_toggled)
	$LocalChkBx.toggled.connect(self._on_localchkbx_toggled)

func _on_unboundedchkbx_toggled(toggled: bool) -> void:
	features[Features.UNBOUNDED] = toggled
	feature_changed.emit(_generate_feature_list())
	
func _on_viewerchkbx_toggled(toggled: bool) -> void:
	features[Features.VIEWER] = toggled
	feature_changed.emit(_generate_feature_list())
	
func _on_localfloorchkbx_toggled(toggled: bool) -> void:
	features[Features.LOCAL_FLOOR] = toggled
	feature_changed.emit(_generate_feature_list())
	
func _on_localchkbx_toggled(toggled: bool) -> void:
	features[Features.LOCAL] = toggled
	feature_changed.emit(_generate_feature_list())

func get_features(input_features: String) -> void:
	var input_array = input_features.split(", ")
	
	for feature in input_array:
		if feature in features_str_enum:
			var get_enum:Features = features_str_enum[feature]
			features[get_enum] = true
	
	$UnboundedChkBx.button_pressed = features[Features.UNBOUNDED]
	$ViewerChkBx.button_pressed = features[Features.VIEWER]
	$LocalFloorChkBx.button_pressed = features[Features.LOCAL_FLOOR]
	$LocalChkBx.button_pressed = features[Features.LOCAL]
