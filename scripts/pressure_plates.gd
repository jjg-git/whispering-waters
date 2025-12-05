extends Node3D

var activation_bitmap: int = 0
var required_bitmap: int = 0
var max_count_plates: int = 0

const Plate = preload("res://scripts/pressure_plate.gd")
var plate_array: Array = []

signal finish

func _ready() -> void:
	for i in get_children():
		if i is Plate:
			plate_array.append(i)
			i.activate.connect(activate_bit)
			i.deactivate.connect(deactivate_bit)
	
	print("Initialize plate indeces")
	for i in plate_array.size():
		plate_array[i].bit_index = i
		print(plate_array[i], ": ", plate_array[i].bit_index)
		required_bitmap |= 1 << i

func activate_bit(bit_index: int):
	activation_bitmap |= 1 << bit_index
	if activation_bitmap == required_bitmap:
		finish.emit()

func deactivate_bit(bit_index: int):
	activation_bitmap &= ~(1 << bit_index)
