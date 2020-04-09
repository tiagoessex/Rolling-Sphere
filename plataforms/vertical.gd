
extends Node2D

var bActive = true

func _ready():
	add_to_group(get_node("/root/globals").GP_PLATAFORMS)
	add_to_group(get_node("/root/globals").GP_PLATAFORM_VERTICAL)


func restart():
	pass

