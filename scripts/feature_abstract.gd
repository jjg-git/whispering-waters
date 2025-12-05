@abstract
extends FlowContainer

class_name FeatureAbstract

signal space_changed(space: String)
signal feature_changed(features_str: String)

var features: Array[bool] = [false, false, false, false]

enum Features {
	UNBOUNDED,
	VIEWER,
	LOCAL_FLOOR,
	LOCAL
}

var features_name: Dictionary = {
	Features.UNBOUNDED: "unbounded",
	Features.VIEWER: "viewer",
	Features.LOCAL_FLOOR: "local-floor",
	Features.LOCAL: "local"
}

var features_str_enum: Dictionary = {
	"unbounded": Features.UNBOUNDED,
	"viewer": Features.VIEWER,
	"local-floor": Features.LOCAL_FLOOR,
	"local": Features.LOCAL
}


func _generate_feature_list() -> String:
	var result: String = ""
	
	var selected_features:Array[String] = []
	for i in features.size():
		if features[i] == true:
			selected_features.append(features_name[i])
	
	var _size = selected_features.size()
	var second_2_last_idx = _size - 2
	
	for i in _size:
		result += selected_features[i]
		if i <= second_2_last_idx:
			result += ", "
	
	return result

@abstract
func get_features(input_features: String) -> void
