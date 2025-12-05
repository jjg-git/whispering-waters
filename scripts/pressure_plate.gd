extends Area3D

var bit_index = 0

signal activate(index: int)
signal deactivate(index: int)


func _on_area_3d_body_entered(_body: Node3D) -> void:
	activate.emit(bit_index)

func _on_area_3d_body_exited(_body: Node3D) -> void:
	deactivate.emit(bit_index)
